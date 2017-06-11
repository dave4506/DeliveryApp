//
//  DateModifier.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import AFDateHelper

struct DateModifier {

    static func getDaysLeft(estDate: String?) -> Int? {
        guard let estDate = estDate else { return nil }
        var date = Date()
        
        let now = Date()
        
        date = Date(fromString: estDate, format: .custom("yyyy-MM-dd'T'HH:mm:ssZ"))!

        return Int(now.since(date, in: .day))
    }

    static func format(date:String) -> Date {
        return Date(fromString: date, format: .custom("yyyy-MM-dd'T'HH:mm:ssZ"))!
    }
}
