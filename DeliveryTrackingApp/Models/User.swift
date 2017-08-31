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
    var userSettingHandle:DatabaseHandle?
    var userSettingRef:DatabaseReference?
    let userSettingsVar = Variable<UserSettings>(UserSettings(lastUpdate:nil,firstTime:nil,notificationEnabled:nil,purchases:nil))
    
    init() {
    }
    
    deinit {
        stopListen()
    }
    
    func stopListen() {
        guard let handler = userSettingHandle else { return }
        userSettingRef?.removeObserver(withHandle: handler)
    }
    
    func observeUserSettings() {
        guard let uid = getCurrentUser()?.uid else { return }
        userSettingRef = Database.database().reference().child("user_settings").child(uid)
        userSettingHandle = userSettingRef?.observe(.value, with: { [unowned self] snap in
            if let dict = snap.value as? [String:AnyObject] {
                self.userSettingsVar.value = UserSettings.convert(dict: dict)
            }
        })
    }
    
    func logInUserRx() -> Observable<User> {
        if let user = Auth.auth().currentUser {
            return Observable.just(user)
        } else {
            return Observable.create { [unowned self] observer in
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
    
    func updateUserSettings(_ newUserSettings:UserSettings) {
        guard let uid = getCurrentUser()?.uid else { return }
        var updates = [:] as [String : Any]
        if let lastUpdate = newUserSettings.lastUpdate { updates["/user_settings/\(uid)/last_update"] = lastUpdate }
        if let firstTime = newUserSettings.firstTime { updates["/user_settings/\(uid)/fist_time"] = firstTime }
        if let notif = newUserSettings.notificationEnabled { updates["/user_settings/\(uid)/notifcation_enabled"] = notif }
        if let purchases = newUserSettings.purchases { updates["/user_settings/\(uid)/purchases"] = purchases }
        Database.database().reference().updateChildValues(updates)
    }
    
    func getUserSettings() -> Observable<UserSettings?> {
        guard let uid = getCurrentUser()?.uid else { return Observable<UserSettings?>.just(nil) }
        print("trying to get user settings")
        return Observable.create { observer in
            Database.database().reference(withPath: "/user_settings/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                print("exists: \(snapshot.exists())")
                if let value = snapshot.value as? [String:AnyObject], snapshot.exists() {
                    observer.on(.next(UserSettings.convert(dict:value)))
                    observer.onCompleted()
                } else {
                    observer.on(.next(nil))
                    observer.onCompleted()
                }
            }) { (error) in
                print("error?")
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }

    
}
