//
//  PackageSettingsViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/9/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import Firebase

class OnboardViewModel {
    
    let userModel:UserModel
    
    func seenOnboard() {
        userModel.updateUserSettings(UserSettings(lastUpdate: nil, firstTime: false, notificationEnabled: nil, purchases: nil))
    }
    
    init() {
        userModel = UserModel()
    }
    
    deinit {
    }
}
