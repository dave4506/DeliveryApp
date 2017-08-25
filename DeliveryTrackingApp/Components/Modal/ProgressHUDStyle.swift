//
//  ProgressHUDStyle.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import SVProgressHUD

enum ProgressHUDStatus {
    
    case success(text:String), error(text:String), loading(text:String)
    
    static func showAndDismiss(_ status: ProgressHUDStatus) {
        ProgressHUDStatus.generateStatusHudStyle()
        switch status {
        case let success(text): SVProgressHUD.showSuccess(withStatus: text); break;
        case let error(text): SVProgressHUD.showError(withStatus: text); break;
        case let loading(text): SVProgressHUD.show(withStatus: text); break;
        }
        SVProgressHUD.dismiss(withDelay: 0.9)
    }
    
    static func generateStatusHudStyle() {
        SVProgressHUD.setFont(UIFont(name: Assets.typeFace.regular, size: 14))
        SVProgressHUD.setCornerRadius(10)
        SVProgressHUD.setBackgroundColor(Color.primary)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setErrorImage(Assets.logo.cross.red)
        SVProgressHUD.setSuccessImage(Assets.logo.check.green)
    }
}
