//
//  Status.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit

struct PrettyStatus {
    let title:String?
    let icon:UIImage?
    let description:String?
    let caption:String?
    let actionable:Bool?
    let buttonTitle:String?
}

enum NotificationStatus:String {
    case basic = "basic"
    case none = "none"
    case everything = "everything"
}

enum NetworkStatus:String {
    case error = "error"
    case uninitiated = "unintiated"
    case loading = "loading"
    case complete = "complete"
}

struct UserInterfaceStatus {
    let networkStatus: NetworkStatus!
    let modalContent: PrettyStatus!
}

struct NotificationOptionStatus {
    let description:String
    let label:String
    let notification:NotificationStatus
}
