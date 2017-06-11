//
//  PackageListViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/5/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Firebase

enum ArchiveListViewPackagesState {
    case unintiated, empty, loading, complete(packages:[PrettyPackage]), error(Error)
}
class ArchiveListViewModel {
    
    var userModel:UserModel? = nil
    let disposeBag = DisposeBag()
    let firebaseRef = Database.database()
    let packages = Variable<ArchiveListViewPackagesState>(.loading)
    
    init() {
    }
    
    deinit {
        
    }
}

extension ArchiveListViewModel {
    
    func firebaseListen() {
        packages.value = .loading
        initiateFirebaseListen()?.flatMap({ [weak self] id -> Observable<[String:AnyObject]> in
            return (self?.pullPackageDetails(id: id))! //may not be right
        }).map { [weak self] pack in
            return Package.convPackageDictionary(pack)
        }.flatMap { pack in
            return Shippo.pullPackage(package:pack).map {
                return ($0,pack)
            }
        }.map { (dict,p) -> PrettyPackage? in
            guard let dict = dict else { return nil }
            var package = p
            package.trackingDetailsDict = dict
            return PrettyPackage.convert(package: package)
        }.toArray().map{ packages -> [PrettyPackage] in
            let sanitized:[PrettyPackage] = packages.filter { $0 != nil }.map { return $0! }
            return sanitized.sorted { (p1,p2) in
                return p1.statusDate < p2.statusDate
            }
        }.subscribe(onNext: { [weak self] packages in
            if packages.isEmpty {
                self?.packages.value = .empty
            } else {
                self?.packages.value = .complete(packages:packages)
            }
        },onError:    { [weak self] (error) in
            print("Error is \(error)")
            self?.packages.value = .error(error)
        }).disposed(by: disposeBag)
    }
    
    func initiateFirebaseListen() -> Observable<String>? {
        guard let uid = userModel?.getCurrentUser()?.uid else { return nil }
        return Observable.create { [weak self] observer in
            let userPackagesRef = self?.firebaseRef.reference(withPath: "/user_packages/\(uid)")
            let refHandle = userPackagesRef?.observeSingleEvent(of:.value, with: { snapshot in
                let postPackages = snapshot.value as? [String:AnyObject] ?? [:]
                Array(postPackages.keys).forEach({
                    observer.on(.next($0))
                })
                observer.onCompleted()
            }) { (error) in
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func pullPackageDetails(id:String) -> Observable<[String:AnyObject]> {
        return Observable.create { [weak self] observer in
            self?.firebaseRef.reference(withPath: "/packages/\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                var value = snapshot.value as! [String:AnyObject]
                value["id"] = snapshot.key as AnyObject
                observer.on(.next(value))
                observer.onCompleted()
            }) { (error) in
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }
}
