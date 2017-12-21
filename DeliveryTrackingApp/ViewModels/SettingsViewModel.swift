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
    case on,off,unintiated,initOn,initOff
    func convertToBool() -> Bool? {
        switch self {
        case .initOn: fallthrough
        case .on: return true;
        case .initOff: fallthrough
        case .off: return false;
        default: return nil;
        }
    }
    
    static func convertBack(_ b:Bool?) -> NotificationSetting {
        guard let bool = b else { return .unintiated }
        return bool ? .on:.off
    }
    
    static func convertBackInit(_ b:Bool?) -> NotificationSetting {
        guard let bool = b else { return .unintiated }
        return bool ? .initOn:.initOff
    }
}

class SettingsViewModel {
    let disposeBag = DisposeBag()
    let userModel = UserModel()
    let userSettingsModel = UserSettingsModel()
    let iapModel = IAPModel()
    let notificationInput = Variable<NotificationSetting>(.unintiated)
    let proPackStatus = Variable<Bool>(false)
    let settingsStatus = Variable<String>("")
    
    init() {
        iapModel.requestProducts()
        userSettingsModel.pullObservable().subscribe(onNext: { [unowned self] in
            guard let us = $0 else { return }
            self.proPackStatus.value = (us.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
            if let value = us.notificationEnabled {
                self.notificationInput.value = NotificationSetting.convertBackInit(value)
            }
        }).disposed(by: disposeBag)
        DelegateHelper.connectionObservable().subscribe(onNext: { [unowned self] in
            switch $0 {
            case .connected: self.settingsStatus.value = "Up to date"; break;
            case .disconnected: self.settingsStatus.value = "Offline"; break;
            default: break;
            }
        }).disposed(by: disposeBag)
    }
    
    deinit {
        
    }
    
    func updateNotificationState() {
        if notificationInput.value != .unintiated {
            userSettingsModel.change(changes: [.notification(notificationInput.value.convertToBool()!)])
        }
    }
    
    func restorePurchases() {
        iapModel.restorePurchases()
    }
    
    func buyProPack() {
        iapModel.buyProduct(IAPIdentifiers.proPack.rawValue)
    }
}
