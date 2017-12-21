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
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
