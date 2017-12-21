//
//  UserSettings.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct UserSettings:RawData {
    let lastUpdate:Int?
    let firstTime:Bool?
    let notificationEnabled:Bool?
    let purchases:[String]?
}

extension UserSettings {
    static func standard() -> UserSettings {
        return UserSettings(lastUpdate: nil, firstTime: true, notificationEnabled: true, purchases: ["free"])
    }
}

extension UserSettings:Convertible {
    static func convert( dict:[String:AnyObject]) -> UserSettings {
        var purchases:[String] = []
        if let d = dict["purchases"] as? [String:String] {
            purchases = Array(d.values)
        }
        return UserSettings(lastUpdate: dict["last_update"] as? Int, firstTime: dict["fist_time"] as? Bool,notificationEnabled: dict["notifcation_enabled"] as? Bool,purchases: purchases)
    }
}

enum UserSettingsChange:RawChange {
    case purchases([String]), notification(Bool), firstTime(Bool), lastUpdate(Int)
}
