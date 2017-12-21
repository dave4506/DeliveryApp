//
//  PackageModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/16/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import Firebase


class PackageModel: Model {
    typealias Data = Package
    let dataVar = Variable<DataModelState<Package>>(.unintiated)
    let disposeBag = DisposeBag()
    let userModel = UserModel()
    var id:String?
    
    init(id:String?) {
        self.id = id
    }
}

extension PackageModel: Changeable {
    typealias Change = PackageChange
    
    func change(changes: [Change]) {
        guard let id = self.id else { return }
        let updates = changes.reduce([:]) { [unowned self] (updates,change) in
            return self.changeUpdates(updates: updates, change: change, key:id)
        }
        Database.database().reference().updateChildValues(updates)
    }
    
    private func changeUpdates(updates:[String:AnyObject],change:PackageChange,key:String) -> [String:AnyObject] {
        guard let uid = userModel.getCurrentUser()?.uid else { return updates }
        var newUpdates = updates
        switch change {
        case let .title(t):
            newUpdates["/packages/\(key)/title"] = t as AnyObject
            break;
        case let .archived(status):
            newUpdates["/packages/\(key)/archived"] = status as AnyObject
            newUpdates["/user_packages/\(uid)/\(key)/archived"] = status as AnyObject
            break;
        case let .notificationState(tier):
            newUpdates["/packages/\(key)/notification_status"] = tier.rawValue as AnyObject
            break;
        }
        return newUpdates
    }
    
}

extension PackageModel: Deletable {
    func delete() {
        guard let uid = userModel.getCurrentUser()?.uid else { return }
        guard let id = id else { return }
        let childUpdates = [
            "/packages/\(id)/":NSNull(),
            "/user_packages/\(uid)/\(id)":NSNull()
            ] as [String : Any]
        Database.database().reference().updateChildValues(childUpdates)
        self.id = nil
        dataVar.value = .unintiated
    }
}

extension PackageModel: Creatable {
    typealias Create = PackageCreate
    static func create(rawData: PackageCreate) {
        let uid = rawData.uid
        let packageRef = Database.database().reference(withPath: "/package")
        let key = packageRef.childByAutoId().key
        let trackingNumber = rawData.trackingNumber.sanitizeForStorage()
        let package = ["uid":uid,
                       "tracking_number":trackingNumber,
                       "title":rawData.title ?? "",
                       "carrier":Carrier.convert(carrier: rawData.carrier),
                       "notification_status":rawData.notificationState.rawValue,
                       "archived":false
            ] as [String : Any]
        let childUpdates = [
            "/user_packages/\(uid)/\(key)":["archived":false],
            "/packages/\(key)":package,
            "cache/\(key)/": [
                "latest":["offline":"no_cache"],"date_updated":0,"uid":uid]
            ] as [String : Any]
        Database.database().reference().updateChildValues(childUpdates)
    }
}

extension PackageModel: Pullable, PullObservable {
    func pull() {
        dataVar.value = .loading
        pullObservable().subscribe(onNext: { [unowned self] in
            guard let p = $0 else { self.dataVar.value = .empty; return }
            self.dataVar.value = .loaded(p)
        }).disposed(by: disposeBag)
    }
    
    func pullObservable() -> Observable<Package?> {
        guard let id = id else { return Observable<Package?>.just(nil) }
        return PackageModel.pullPackageDetails(id: id).flatMap { dict -> Observable<[String : AnyObject]?> in
            if var dict = dict {
                return PackageModel.pullPackageDetails(id:dict["id"] as! String,carrier:dict["carrier"] as! String,trackingNumber:dict["tracking_number"] as! String).map { trackingDict in
                    dict["tracking_details"] = trackingDict as AnyObject
                    return dict
                }
            } else {
                return Observable<[String : AnyObject]?>.just(nil)
            }
        }.map { d -> Package? in
                guard let d = d else { return nil }
                return Package.convert(dict:d)
        }
    }
    
    private static func pullPackageCacheOnline(id:String) -> Observable<[String:AnyObject]?> {
        if DelegateHelper.connectionState() == .connected {
            return Observable.create { observer in
                Database.database().reference(withPath: "/cache/\(id)").runTransactionBlock({
                    return TransactionResult.success(withValue: $0)
                }) { (error, committed, snapshot) in
                    if let _ = error {
                        observer.on(.next(nil))
                    }
                    if let snapshot = snapshot {
                        if let value = snapshot.value as? [String:AnyObject], snapshot.exists() {
                            var latest = value["latest"] as? [String:AnyObject]
                            latest?["date_updated"] = value["date_updated"]
                            observer.on(.next(latest))
                        }
                    }
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        } else {
            return pullPackageCache(id:id)
        }
    }
    
    private static func pullPackageDetails(id:String,carrier:String,trackingNumber:String)-> Observable<[String:AnyObject]?> {
        return  pullPackageCacheOnline(id: id).flatMap { d -> Observable<[String : AnyObject]?> in
            if let dict = d {
                if Package.determineType(dict: dict) == .invalid || (Package.determineType(dict: dict) == .offline && DelegateHelper.connectionState() == .connected) {
                    return ShippoHelper.pullPackage(carrier:carrier,trackingNumber:trackingNumber)
                }
                return Observable.just(dict)
            } else {
                return ShippoHelper.pullPackage(carrier:carrier,trackingNumber:trackingNumber)
            }
        }
    }
    
    private static func pullPackageCache(id:String) -> Observable<[String:AnyObject]?> {
        return Observable.create { observer in
            Database.database().reference(withPath: "/cache/\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? [String:AnyObject], snapshot.exists() {
                    var latest = value["latest"] as? [String:AnyObject]
                    latest?["date_updated"] = value["date_updated"]
                    observer.on(.next(latest))
                    observer.onCompleted()
                } else {
                    observer.on(.next(nil))
                    observer.onCompleted()
                }
            }) { (error) in
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }
    
    private static func pullPackageDetails(id:String) -> Observable<[String:AnyObject]?> {
        return Observable.create { observer in
            Database.database().reference(withPath: "/packages/\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
                if var value = snapshot.value as? [String:AnyObject], snapshot.exists() {
                    value["id"] = snapshot.key as AnyObject
                    observer.on(.next(value))
                    observer.onCompleted()
                } else {
                    observer.on(.next(nil))
                    observer.onCompleted()
                }
            }) { (error) in
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }
}



