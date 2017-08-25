//
//  Package.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/20/17.

//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

internal struct PackageKeywords {
    static let outForDelivery = [
        KeyWordSearch(words:["on","vehicle","delivery"]),
        KeyWordSearch(words:["out","for","delivery"])
    ]
    static let awaiting = [
        KeyWordSearch(words:["shipment","information","sent"]),
        KeyWordSearch(words:["shipment","information","received"]),
        KeyWordSearch(words:["awaiting","carrier","pickup"])
    ]
    static let delay = [
        KeyWordSearch(words:["parcel","delay"]),
        KeyWordSearch(words:["shipment","delay"]),
        KeyWordSearch(words:["package","delay"]),
        KeyWordSearch(words:["packet","delay"])
    ]
}

struct PrettyPackage {
    let title:String?
    let id:String!
    let trackingNumber:String!
    let carrier:String!
    let status:PackageStatus!
    let statusDate:Date!
    let statusLocation:Location?
    let package:Package?
    var trail:Trail?
    let trackingTimeline:[TrackingLocationHistory]?
    let durationPercentage:Double?
    let read:Bool
}

extension PrettyPackage {
    
    static func convert(package:Package) -> PrettyPackage {
        switch PrettyPackage.testValidDict(dict: package.trackingDetailsDict!) {
        case .invalid: return PrettyPackage.convertInvalid(package)
        case .valid: return PrettyPackage.convertValid(package)
        case .offline: return PrettyPackage.convertOffline(package)
        }
    }
    
    static func convertInvalid(_ package:Package) -> PrettyPackage {
        let prettyPackage = PrettyPackage(
            title: package.title,
            id: package.id,
            trackingNumber: package.trackingNumber,
            carrier: package.carrier.description,
            status: PrettyPackage.determineInvalidStatus(package: package),
            statusDate: Date(),
            statusLocation:Location(city:"Somewhere",country:nil,state:nil,zip:nil),
            package: package,
            trail: nil,
            trackingTimeline: nil,
            durationPercentage: 0.0,
            read:determineRead(package: package)
        )
        return prettyPackage
    }
    
    static func convertOffline(_ package:Package) -> PrettyPackage {
        let prettyPackage = PrettyPackage(
            title: package.title,
            id: package.id,
            trackingNumber: package.trackingNumber,
            carrier: package.carrier.description,
            status: .unknown,
            statusDate: Date(),
            statusLocation:Location(city:"Somewhere",country:nil,state:nil,zip:nil),
            package: package,
            trail: nil,
            trackingTimeline: nil,
            durationPercentage: 0.0,
            read:false
        )
        return prettyPackage
    }
    
    static func convertValid(_ package:Package) -> PrettyPackage {
        let dict = package.trackingDetailsDict!
        let status = PrettyPackage.determineValidStatus(dict:dict)
        let prettyPackage = PrettyPackage(
            title: package.title,
            id: package.id,
            trackingNumber: package.trackingNumber,
            carrier: package.carrier.description,
            status: status,
            statusDate: DateHelper.format(date: (dict["tracking_status"] as! [String:AnyObject])["status_date"] as! String),
            statusLocation:Location.convert(dict: (dict["tracking_status"] as! [String:AnyObject])["location"] as! [String:AnyObject]),
            package: package,
            trail: nil,
            trackingTimeline: TrackingLocationHistory.generateTrackingTimeline(dict:dict),
            durationPercentage: generatePercentage(status: status, dict: dict),
            read:determineRead(package: package)
        )
        return prettyPackage
    }
}

extension PrettyPackage {
    
    static func testValidDict(dict:[String:AnyObject?]) -> PackageDictType {
        if let _ = dict["tracking_status"] as? [String:AnyObject] {
            return .valid
        } else if let _ = dict["offline"] as? String {
            return .offline
        } else {
            return .invalid
        }
    }
    
    static func determineInvalidStatus(package:Package) -> PackageStatus {
        let guesses = Carrier.guess(from: package.trackingNumber)
        let correctCarrier = guesses.contains(where: {
            return $0.1 == package.carrier
        })
        return correctCarrier ? .awaiting:.unknown
    }
    
    static func determineValidStatus(dict:[String:AnyObject]) -> PackageStatus {
        let trackingStatus = dict["tracking_status"] as! [String:AnyObject]
        let statusString = trackingStatus["status"] as! String
        let statusDetails = trackingStatus["status_details"] as! String
        switch statusString {
        case "DELIVERED": return .delivered
        case "TRANSIT":
            if KeyWordSearch.searchMany(keywordSearches: PackageKeywords.outForDelivery, string: statusDetails) {
                return .outForDelivery
            }
            return .traveling(daysLeft:DateHelper.getDaysLeft(estDate: dict["eta"] as? String))
        case "FAILURE": return .error
        default:
            if KeyWordSearch.searchMany(keywordSearches: PackageKeywords.awaiting, string: statusDetails) {
                return .awaiting
            }
            if KeyWordSearch.searchMany(keywordSearches: PackageKeywords.delay, string: statusDetails) {
                return .delay(ogDaysLeft:DateHelper.getDaysLeft(estDate: dict["eta"] as? String))
            }
            return .unknown
        }
    }
}

extension PrettyPackage {
    
    static func determineRead(package:Package) -> Bool {
        let dict = package.trackingDetailsDict!
        guard let cacheReadTimeStamp = package.cacheReadTimeStamp else { return false }
        guard let dateUpdated = dict["date_updated"] else { return false }
        return cacheReadTimeStamp >= dateUpdated as! Int
    }
    
    static func generatePercentage(status:PackageStatus,dict:[String:AnyObject]) -> Double {
        switch status {
        case .delivered: return 1;
        case .outForDelivery: return 0.95;
        case .unknown: return 0;
        case .awaiting: return 0;
        case .delay: fallthrough
        case .error: fallthrough
        case .traveling:
            if let etaString = dict["eta"] as? String {
                let etaDate =  DateHelper.format(date: etaString )
                let trackingHistory = dict["tracking_history"] as! [[String:AnyObject]]
                if let firstTrack = trackingHistory.first {
                    let firstDate = DateHelper.format(date: firstTrack["status_date"] as! String )
                    let totalDuration = etaDate.since(firstDate, in:.day)
                    let completedDuration = DateHelper.dateAtStart().since(firstDate, in:.day)
                    let percentage = Double(completedDuration) / Double(totalDuration)
                    return percentage == 1 ? 0.9: percentage
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }
    }
}
