//
//  PackageStatus.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/17/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

enum PackageState:State {
    case uninitialized,awaiting,error,unknown,delay(ogDaysLeft:Int?),delivered,traveling(daysLeft:Int?),outForDelivery
}

extension PackageState: Equatable {
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

extension PackageState:CustomStringConvertible {
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
