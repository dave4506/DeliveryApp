//
//  UserSettings.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct UserSettings {
    let lastUpdate:Int?
    let firstTime:Bool?
    let notificationEnabled:Bool?
    let purchases:[String]?

    static func convert( dict:[String:AnyObject]) -> UserSettings {
        var purchases:[String] = []
        if let d = dict["purchases"] as? [String:String] {
            purchases = Array(d.values)
            print("purchases: \(purchases)")
        }
        return UserSettings(lastUpdate: dict["last_update"] as? Int, firstTime: dict["fist_time"] as? Bool,notificationEnabled: dict["notifcation_enabled"] as? Bool,purchases: purchases)
    }
}
