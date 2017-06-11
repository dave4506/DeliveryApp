//
//  Package.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/20/17.

//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift

struct PackageKeywords {
    static let outForDelivery = [
        KeyWordSearch(words:["on","vehicle","delivery"]),
        KeyWordSearch(words:["out","for","delivery"])
    ]
    static let awaiting = [
        KeyWordSearch(words:["shipment","information","sent"]),
        KeyWordSearch(words:["shipment","information","received"])
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
    let package:Package?
    var trail:Trail?
    let trackingTimeline:[TrackingLocationHistory]?
    let durationPercentage:Double?
    
    static func convert(package:Package) -> PrettyPackage {
        let dict = package.trackingDetailsDict!
        let status = PrettyPackage.determineStatus(dict:dict)
        let prettyPackage = PrettyPackage(
            title: package.title,
            id: package.id,
            trackingNumber: package.trackingNumber,
            carrier: package.carrier.description,
            status: status,
            statusDate: DateModifier.format(date: (dict["tracking_status"] as! [String:AnyObject])["status_date"] as! String),
            package: package,
            trail: nil,
            trackingTimeline: PrettyPackage.generateTrackingTimeline(dict:dict),
            durationPercentage: generatePercentage(status: status, dict: dict)
        )
        return prettyPackage
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
                let etaDate =  DateModifier.format(date: etaString )
                let trackingHistory = dict["tracking_history"] as! [[String:AnyObject]]
                if let firstTrack = trackingHistory.first {
                    let firstDate = DateModifier.format(date: firstTrack["status_date"] as! String )
                    let totalDuration = etaDate.since(firstDate, in:.day)
                    let completedDuration = Date().since(firstDate, in:.day)
                    return Double(completedDuration / totalDuration)
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }
    
    }
    
    static func generateMapTrails(dict:[String:AnyObject]) -> Observable<Trail> {
        return Position.convert(location: Location.convert(dict: dict["address_from"] as! [String:AnyObject])).flatMap { from -> Observable<Trail> in
            if let to = dict["address_to"] as? [String:AnyObject] {
                return Position.convert(location: Location.convert(dict:to)).flatMap {
                    return Observable<Trail>.just(Trail(from:from,destination:$0,path:[]))
                }
            } else {
                return Observable<Trail>.just(Trail(from:from,destination:nil,path:[]))
            }
            }.flatMap { trail -> Observable<Trail> in
                let trackingHistory = dict["tracking_history"] as! [[String:AnyObject]]
                let locations = trackingHistory.map { Location.convert(dict: $0["location"] as! [String:AnyObject]) }
                var sanitizedlocations:[Location] = []
                if let first = locations.first {
                    sanitizedlocations.append(first)
                }
                locations.forEach {
                    let last = sanitizedlocations.last ?? $0
                    if last != $0 {
                        sanitizedlocations.append($0)
                    }
                }
                sanitizedlocations = sanitizedlocations.filter { $0.valid() }
                print(sanitizedlocations)
                return Observable.from(sanitizedlocations).flatMap { location in
                    return Position.convert(location: location).flatMap { pos -> Observable<(Position,Int)> in
                        return Observable.just((pos!,Int(sanitizedlocations.index(of: location)!)))
                    }
                }.toArray().flatMap { pathTuples -> Observable<Trail> in
                    let sortedTuples = pathTuples.sorted(by: { $0.1 < $1.1 })
                    let path = sortedTuples.map { $0.0 }
                    return Observable<Trail>.just(Trail(from:trail.from,destination:trail.destination,path:path))
                }
        }
    }
    
    static func determineStatus(dict:[String:AnyObject]) -> PackageStatus {
        let trackingStatus = dict["tracking_status"] as! [String:AnyObject]
        let statusString = trackingStatus["status"] as! String
        let statusDetails = trackingStatus["status_details"] as! String
        switch statusString {
        case "DELIVERED": return .delivered
        case "TRANSIT":
            if KeyWordSearch.searchMany(keywordSearches: PackageKeywords.outForDelivery, string: statusDetails) {
                return .outForDelivery
            }
            return .traveling(daysLeft:DateModifier.getDaysLeft(estDate: dict["eta"] as? String))
        case "FAILURE": return .error
        default:
            if KeyWordSearch.searchMany(keywordSearches: PackageKeywords.awaiting, string: statusDetails) {
                return .awaiting
            }
            if KeyWordSearch.searchMany(keywordSearches: PackageKeywords.delay, string: statusDetails) {
                return .delay(ogDaysLeft:DateModifier.getDaysLeft(estDate: dict["eta"] as? String))
            }
            return .unknown
        }
    }
    
    static func generateTrackingTimeline(dict:[String:AnyObject]) -> [TrackingLocationHistory] {
        let trackingHistory = dict["tracking_history"] as! [[String:AnyObject]]
        var trackingTimeline:[TrackingLocationHistory] = []
        trackingHistory.forEach { track in
            var newTrackingLocationHistory = TrackingLocationHistory(time: DateModifier.format(date: track["status_date"] as! String), location: Location.convert(dict: track["location"] as! [String:AnyObject]), trackingHistory: [])
            var lastTrackingLocationHistory = trackingTimeline.last ?? newTrackingLocationHistory
            
            if lastTrackingLocationHistory == newTrackingLocationHistory {
                lastTrackingLocationHistory.trackingHistory.append(TrackingHistory.convert(dict:track))
                let _ = trackingTimeline.popLast()
                trackingTimeline.append(lastTrackingLocationHistory)
            } else {
                newTrackingLocationHistory.trackingHistory.append(TrackingHistory.convert(dict:track))
                trackingTimeline.append(newTrackingLocationHistory)
            }
            
        }
        return trackingTimeline
    }
}

struct TrackingHistory {
    let details:String!
    let time:Date!
    
    static func convert(dict:[String:AnyObject]) -> TrackingHistory {
        return TrackingHistory(
            details:dict["status_details"] as! String,
            time:DateModifier.format(date: dict["status_date"] as! String)
        )
    }
}

struct TrackingLocationHistory {
    let time:Date!
    let location:Location?
    var trackingHistory:[TrackingHistory]!
    
}

extension TrackingLocationHistory: Equatable {
    static func == (lhs: TrackingLocationHistory, rhs: TrackingLocationHistory) -> Bool {
        return
                lhs.time.compare(.isSameDay(as: rhs.time)) &&
                lhs.location == rhs.location
    }
}

//WORK ON RETURNED?
enum PackageStatus {
    case awaiting,error,unknown,delay(ogDaysLeft:Int?),delivered,traveling(daysLeft:Int?),outForDelivery
}

extension PackageStatus:CustomStringConvertible {
    var description: String {
        switch self {
        case .awaiting:
            return "Awaiting"
        case .error:
            return "Hiccup"
        case .unknown:
            return "No clue"
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

struct Package {
    var id: String
    var trackingNumber: String
    var carrier: Carrier
    var title: String
    var status: PackageStatus = .unknown
    var trackingDetailsDict: [String:AnyObject]?
    var notificationStatus:NotificationStatus?
    var archived: Bool 
}

extension Package {
    //TODO FIX actual
    static func convPackageDictionary(_ packDict:[String:AnyObject]) -> Package {
        return Package(id: packDict["id"] as! String,trackingNumber: packDict["tracking_number"] as! String, carrier: Carrier.convShippo(from: packDict["carrier"] as! String), title: packDict["title"] as! String, status: .unknown, trackingDetailsDict: nil,notificationStatus:.basic,archived:false)
    }
}
