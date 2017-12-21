//
//  Status.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/23/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit

/* Relocate to form system */

struct NotificationOptionStatus {
    let description:String
    let label:String
    let notification:NotificationTiers
}

struct SimpleTableData {
    var title:String!
    var description:String!
}

struct AlertViewStatus {
    let title:String
    let description:String
}

struct PrettyStatus {
    let title:String?
    let icon:UIImage?
    let description:String?
    let caption:String?
    let actionable:Bool?
    let buttonTitle:String?
}
