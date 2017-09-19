//
//  UserPackagesModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/16/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class UserPackagesModel: Model, Watchable {
    typealias Data = UserPackages
    typealias PackageKeys = String
    let dataVar = Variable<DataModelState<UserPackages>>(.unintiated)
    let disposeBag = DisposeBag()
    let userModel = UserModel()
    
    var handler:DatabaseHandle?
    var ref:DatabaseReference?
    let packageKeysVar = Variable<[PackageKeys]>([])
    
    func watch() {
        guard let uid = userModel.getCurrentUser()?.uid else { return }
        ref = Database.database().reference(withPath: "/user_packages/\(uid)")
        handler = ref!.observe(.value, with: { [unowned self] snap in
            if let dict = snap.value as? [String:AnyObject] {
                self.packageKeysVar.value = Array(dict.keys)
            }
        })
    }
    
    func stop() {
        guard let handler = handler else { return }
        ref?.removeObserver(withHandle: handler)
    }
    
    deinit {
         stop()
    }
}

extension UserPackagesModel: Pullable, PullObservable {
    
    func pull() {
        dataVar.value = .loading
        pullObservable().subscribe(onNext: { [unowned self] in
            if let up = $0 {
                self.dataVar.value = .loaded(up)
            } else {
                self.dataVar.value = .empty
            }
        }).disposed(by:disposeBag)
    }
    
    func pullObservable() -> Observable<UserPackages?> {
        guard let uid = userModel.getCurrentUser()?.uid else { return  Observable<UserPackages?>.just(nil) }
        return Observable<String>.create { observer in
            let userPackagesRef = Database.database().reference(withPath: "/user_packages/\(uid)")
            userPackagesRef.observeSingleEvent(of:.value, with: { snapshot in
                let postPackages = snapshot.value as? [String:AnyObject] ?? [:]
                Array(postPackages.keys).forEach({
                    observer.on(.next($0))
                })
                observer.onCompleted()
            }) { (error) in
                observer.on(.error(error))
            }
            return Disposables.create()
        }.flatMap { id -> Observable<Package?> in
            let packageModel = PackageModel(id: id)
            return packageModel.pullObservable()
        }.toArray().map { [unowned self] (packages:[Package?]) -> UserPackages? in
            return self.sort(packages:packages)
        }
    }
    
    private func sort(packages:[Package?]) -> UserPackages {
        let filteredPackages = packages.filter { $0 == nil } as! [Package]
        return UserPackages(currentPackages: filteredPackages.filter { $0.archived }, archivedPackages:  filteredPackages.filter { !$0.archived })
    }
}



