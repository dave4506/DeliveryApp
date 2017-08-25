//
//  UserModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class UserModel {
    let disposeBag = DisposeBag()
    let userId = BehaviorSubject<String>(value: "test_user")
    
    init() {
    }
    
    func logInUserRx() -> Observable<User> {
        if let user = Auth.auth().currentUser {
            return Observable.just(user)
        } else {
            return Observable.create { observer in
                Auth.auth().signInAnonymously() { (user, error) in
                    if let u = user {
                        observer.on(.next(u))
                    }
                    if let e = error {
                        observer.on(.error(e))
                    }
                    observer.on(.completed)
                }
                return Disposables.create()
            }
        }
    }
    
    func logInUser() {
        Auth.auth().signInAnonymously() { [weak self] (user, error) in
            if let u = user {
                self?.userId.onNext(u.uid)
            }
            if let e = error {
                self?.userId.onError(e)
            }
        }
    }
    
    func getCurrentUser() -> User? {
        if Auth.auth().currentUser == nil {
            logInUser()
        }
        return Auth.auth().currentUser
    }
}
