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

enum NotificationStatus {
    case basic, none, everything
}

enum NetworkStatus {
    case error, uninitiated, loading, complete
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
