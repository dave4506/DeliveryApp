//
//  Notification.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/17/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

enum NotificationTiers:String {
    case basic = "basic"
    case none = "none"
    case everything = "everything"
    
    static func convert(_ str:String) -> NotificationTiers {
        switch str {
        case "basic": return .basic
        case "none": return .none
        case "everything": return .everything
        default: return .basic;
        }
    }
}
