//
//  UserSettingsModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/17/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class UserSettingsModel: Model, Watchable {
    typealias Data = UserSettings
    let dataVar = Variable<DataModelState<UserSettings>>(.unintiated)
    let disposeBag = DisposeBag()
    let userModel = UserModel()
    var handler:DatabaseHandle?
    var ref:DatabaseReference?
    
    func watch() {
        guard let uid = userModel.getCurrentUser()?.uid else { return }
        ref = Database.database().reference().child("user_settings").child(uid)
        handler = ref!.observe(.value, with: { [unowned self] snap in
            if let dict = snap.value as? [String:AnyObject] {
                self.dataVar.value = .loaded(UserSettings.convert(dict: dict))
            }
        })
    }
    
    func stop() {
        guard let handler = handler else { return }
        ref?.removeObserver(withHandle: handler)
    }
}

extension UserSettingsModel: Pullable, PullObservable {
    func pull() {
        dataVar.value = .loading
        pullObservable().subscribe(onNext: { [unowned self] in
            if let us = $0 {
                self.dataVar.value = .loaded(us)
            } else {
                self.dataVar.value = .empty
            }
        }).disposed(by:disposeBag)
    }
    
    func pullObservable() -> Observable<UserSettings?> {
        guard let uid = userModel.getCurrentUser()?.uid else { return Observable<UserSettings?>.just(nil) }
        return Observable.create { observer in
            Database.database().reference(withPath: "/user_settings/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? [String:AnyObject], snapshot.exists() {
                    observer.on(.next(UserSettings.convert(dict:value)))
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

extension UserSettingsModel: Changeable {
    typealias Change = UserSettingsChange
    
    func change(changes: [Change]) {
        let updates = changes.reduce([:]) { [unowned self] (updates,change) in
            return self.changeUpdates(updates: updates, change: change)
        }
        Database.database().reference().updateChildValues(updates)
    }
    
    private func changeUpdates(updates:[String:AnyObject],change:UserSettingsChange) -> [String:AnyObject] {
        guard let uid = userModel.getCurrentUser()?.uid else { return updates }
        var newUpdates = updates
        switch change {
        case let .purchases(purchases):
            newUpdates["/user_settings/\(uid)/purchases"] = purchases as AnyObject
            break;
        case let .notification(status):
            newUpdates["/user_settings/\(uid)/notifcation_enabled"] = status as AnyObject
            break;
        case let .firstTime(status):
            newUpdates["/user_settings/\(uid)/fist_time"] = status as AnyObject
            break;
        case let .lastUpdate(dateInt):
            newUpdates["/user_settings/\(uid)/last_update"] = dateInt as AnyObject
            break;
        }
        return newUpdates
    }
}
