//
//  Status.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/23/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit

struct SimpleTableData {
    var title:String!
    var description:String!
}

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
    
    static func convString(_ str:String) -> NotificationStatus {
        switch str {
        case "basic": return .basic
        case "none": return .none
        case "everything": return .everything
        default: return .basic;
        }
    }
}

struct NotificationOptionStatus {
    let description:String
    let label:String
    let notification:NotificationStatus
}

enum PackageStatus {
    case uninitialized,awaiting,error,unknown,delay(ogDaysLeft:Int?),delivered,traveling(daysLeft:Int?),outForDelivery
}

extension PackageStatus: Equatable {
    static func == (lhs: PackageStatus, rhs: PackageStatus) -> Bool {
        switch (lhs, rhs) {
        case (.awaiting,.awaiting), (.error,.error), (.unknown,.unknown), (.delivered,.delivered), (.outForDelivery,.outForDelivery):
            return true
        case let (.traveling(a),.traveling(b)), let (.delay(a),delay(b)):
            return a == b
        default:
            return false
        }
    }
}

extension PackageStatus:CustomStringConvertible {
    var description: String {
        switch self {
        case .awaiting:
            return "Awaiting"
        case .error:
            return "Error"
        case .unknown:
            return "No clue"
        case .uninitialized:
            return " "
        case .delay:
            return "Delayed"
        case .delivered:
            return "Delivered"
        case let .traveling(daysLeft):
            if let dysLeft = daysLeft {
                if dysLeft == 0 {
                    return "Today"
                }
                if dysLeft == 1 {
                    return "In \(dysLeft) Day"
                } else {
                    return "In \(dysLeft) Days"
                }
            } else {
                return "In Transit"
            }
        case .outForDelivery:
            return "Out For Delivery"
        }
    }
}

struct AlertViewStatus {
    let title:String
    let description:String
}
