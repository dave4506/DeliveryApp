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
    let id:String
    
    init(id:String) {
        self.id = id
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
        return pullPackageDetails(id: id).flatMap { [unowned self] dict -> Observable<[String : AnyObject]?> in
            if var dict = dict {
                return self.pullPackageDetails(id:dict["id"] as! String,carrier:dict["carrier"] as! String,trackingNumber:dict["tracking_number"] as! String).map { trackingDict in
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
    
    private func pullPackageDetails(id:String,carrier:String,trackingNumber:String)-> Observable<[String:AnyObject]?> {
        return  pullPackageCache(id: id).flatMap { d -> Observable<[String : AnyObject]?> in
            if let dict = d {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                //move out of pretty package
                if PrettyPackage.testValidDict(dict: dict) == .offline && delegate.connectionModel?.connectionState.value == .connected {
                    return ShippoHelper.pullPackage(carrier:carrier,trackingNumber:trackingNumber)
                }
                return Observable.just(dict)
            } else {
                return ShippoHelper.pullPackage(carrier:carrier,trackingNumber:trackingNumber)
            }
        }
    }
    
    private func pullPackageCache(id:String) -> Observable<[String:AnyObject]?> {
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
    
    private func pullPackageDetails(id:String) -> Observable<[String:AnyObject]?> {
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



