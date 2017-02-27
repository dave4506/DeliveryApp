//
//  DateModifier.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import AFDateHelper

class DateModifier {

    func getDaysLeft(estDate: String) -> String{
        
        var date = Date()
        
        let now = Date()
        
        date = Date(fromString: estDate, format: .custom("yyyy-MM-dd'T'HH:mm:ssZ"))

        
        if(date.isTomorrow()){
            return "TOMORROW"
            
        }
        else if(date.isToday()){
           return "TODAY"
        }
        
        return "\(date.daysAfterDate(now)) DAYS"
        
    }

}
