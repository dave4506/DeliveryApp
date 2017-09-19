//
//  PackageSettingsViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/9/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardViewModel {
    
    let userSettingsModel = UserSettingsModel()
    
    func seenOnboard() {
        userSettingsModel.change(changes: [.firstTime(false)])
    }
}
