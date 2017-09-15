//
//  DateModifier.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import AFDateHelper

enum DateHelper {

    static func getDaysLeft(estDate: String?) -> Int? {
        guard let estDate = estDate else { return nil }
        var date = Date()
        let now = DateHelper.dateAtStart()
        date = Date(fromString: estDate, format: .custom("yyyy-MM-dd'T'HH:mm:ssZ"))!
        return Int(date.since(now, in: .day))
    }

    static func format(date:String) -> Date {
        return Date(fromString: date, format: .custom("yyyy-MM-dd'T'HH:mm:ssZ"))!
    }
    
    static func dateAtStart() -> Date {
        let nowString = Date().toString(format: .isoDate)
        var now = Date.init(fromString: nowString, format: .isoDate)
        now = now!.adjust(hour: -7, minute: 0, second: 0)
        return now!
    }
}
