//
//  TrackingLocation.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/24/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct TrackingHistory {
    let details:String!
    let time:Date!
    
    static func convert(dict:[String:AnyObject]) -> TrackingHistory {
        return TrackingHistory(
            details:dict["status_details"] as! String,
            time:DateHelper.format(date: dict["status_date"] as! String)
        )
    }
}

struct TrackingLocationHistory {
    let time:Date!
    let location:Location!
    var trackingHistory:[TrackingHistory]!
    
    static func generateTrackingTimeline(dict:[String:AnyObject]) -> [TrackingLocationHistory] {
        let trackingHistory = dict["tracking_history"] as! [[String:AnyObject]]
        var trackingTimeline:[TrackingLocationHistory] = []
        trackingHistory.forEach { track in
            var newTrackingLocationHistory = TrackingLocationHistory(time: DateHelper.format(date: track["status_date"] as! String), location: Location.convert(dict: track["location"] as! [String:AnyObject]), trackingHistory: [])
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

extension TrackingLocationHistory: Equatable {
    static func == (lhs: TrackingLocationHistory, rhs: TrackingLocationHistory) -> Bool {
        return
            lhs.time.compare(.isSameDay(as: rhs.time)) &&
                lhs.location == rhs.location
    }
}

