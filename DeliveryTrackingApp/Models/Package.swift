//
//  Package.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/23/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

enum PackageType {
    case valid, offline, invalid
}

typealias PackageId = String

struct Package:RawData {
    var id: PackageId
    var trackingNumber: String
    var carrier: Carrier
    var title: String
    var type: PackageType
    var state: PackageState = .uninitialized
    var trackingDetailsDict: [String:AnyObject]?
    var notificationState:NotificationTiers
    var archived: Bool
    var cacheReadTimeStamp: Int?
}

extension Package:Convertible {
    
    static func determineType(dict trackingDict:[String:AnyObject?]) -> PackageType {
        if let _ = trackingDict["tracking_status"] as? [String:AnyObject] {
            return .valid
        } else if let _ = trackingDict["offline"] as? String {
            return .offline
        } else {
            return .invalid
        }
    }
    
    static func convert(dict:[String:AnyObject]) -> Package {
        var packageType:PackageType = .invalid
        if let trackingDict = dict["tracking_details"] as? [String:AnyObject] {
            packageType = Package.determineType(dict: trackingDict)
        }
        return Package(
            id: dict["id"] as! String,
            trackingNumber: dict["tracking_number"] as! String,
            carrier: Carrier.convert(str: dict["carrier"] as! String),
            title: dict["title"] as! String,
            type: packageType,
            state: .uninitialized,
            trackingDetailsDict: dict["tracking_details"] as? [String:AnyObject],
            notificationState: NotificationTiers.convert(dict["notification_status"] as! String),
            archived:dict["archived"] as! Bool,
            cacheReadTimeStamp:dict["cache_read_time"] as? Int
        )
    }
}

enum PackageChange:RawChange {
    case title(String), archived(Bool), notificationState(NotificationTiers)
}

struct PackageCreate: CreateData {
    let uid:String
    let trackingNumber:String
    let title:String?
    let carrier:Carrier
    let notificationState:NotificationTiers
}
