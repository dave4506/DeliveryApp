//
//  SettingsViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/27/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

enum NotificationSetting {
    case on,off,unintiated
    func convertToBool() -> Bool? {
        switch self {
        case .on: return true;
        case .off: return false;
        default: return nil;
        }
    }
    
    static func convertBack(_ b:Bool?) -> NotificationSetting {
        guard let bool = b else { return .unintiated }
        return bool ? .on:.off
    }
}

class SettingsViewModel {
    let disposeBag = DisposeBag()
    let notificationStatus = Variable<NotificationSetting>(.unintiated)
    let proPackStatus = Variable<Bool>(false)
    let userModel:UserModel
    var userSettingHandle:DatabaseHandle?
    var userSettingRef:DatabaseReference?
    let iapModel:IAPModel
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        userModel = delegate.userModel!
        iapModel = IAPModel()
        iapModel.requestProducts()
        getNotificationStatus()
        userModel.userSettingsVar.asObservable().subscribe(onNext: { [unowned self] in
            self.proPackStatus.value = ($0.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        
    }
    

    func getNotificationStatus() {
        guard let uid = userModel.getCurrentUser()?.uid else { return }
        userSettingRef = Database.database().reference().child("user_settings").child(uid)
        userSettingRef?.observeSingleEvent(of: .value, with: { snap in
            let dict = snap.value as? [String:AnyObject]
            if let value = dict?["notification_enabled"] as? Bool {
                self.notificationStatus.value = NotificationSetting.convertBack(value)
            } else {
                self.notificationStatus.value = NotificationSetting.convertBack(UIApplication.shared.isRegisteredForRemoteNotifications)
            }
        })
    }
    
    func updateNotificationStatus() {
        let notif = notificationStatus.value
        userModel.updateUserSettings(UserSettings(lastUpdate: nil, firstTime: nil, notificationEnabled: notif.convertToBool(), purchases: nil))
    }
    
    func restorePurchases() {
        iapModel.restorePurchases()
    }
    
    func buyProPack() {
        iapModel.buyProduct(IAPIdentifiers.proPack.rawValue)
    }
}
