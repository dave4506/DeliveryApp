//
//  TrackingLocation.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/24/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct TrackingHistory:RawData {
    let details:String!
    let time:Date!
}

extension TrackingHistory:Convertible {
    static func convert(dict:[String:AnyObject]) -> TrackingHistory {
        return TrackingHistory(
            details:dict["status_details"] as! String,
            time:DateHelper.format(date: dict["status_date"] as! String)
        )
    }
}

struct LocationTrackingHistory:RawData {
    let time:Date!
    let location:Location
    var trackingHistory:[TrackingHistory]!
}

extension LocationTrackingHistory:ManyConvertible {
    static func convert(dict:[String:AnyObject]) -> [LocationTrackingHistory] {
        let trackingHistory = dict["tracking_history"] as! [[String:AnyObject]]
        var trackingTimeline:[LocationTrackingHistory] = []
        trackingHistory.forEach { track in
            var location = Location(city:"Somewhere",country:nil,state:nil,zip:nil,geoCode:nil);
            
            if let locDic = track["location"] as? [String:AnyObject] {
                location = Location.convert(dict: locDic)
            }
            
            var newLocationTrackingHistory = LocationTrackingHistory(time: DateHelper.format(date: track["status_date"] as! String), location: location, trackingHistory: [])
            var lastLocationTrackingHistory = trackingTimeline.last ?? newLocationTrackingHistory
            if lastLocationTrackingHistory == newLocationTrackingHistory {
                lastLocationTrackingHistory.trackingHistory.append(TrackingHistory.convert(dict:track))
                let _ = trackingTimeline.popLast()
                trackingTimeline.append(lastLocationTrackingHistory)
            } else {
                newLocationTrackingHistory.trackingHistory.append(TrackingHistory.convert(dict:track))
                trackingTimeline.append(newLocationTrackingHistory)
            }
        }
        return trackingTimeline
    }
}

extension LocationTrackingHistory: Equatable {
    static func == (lhs: LocationTrackingHistory, rhs: LocationTrackingHistory) -> Bool {
        return
            lhs.time.compare(.isSameDay(as: rhs.time)) &&
                lhs.location == rhs.location
    }
}

