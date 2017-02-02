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
            return "Tomorrow"
            
        }
        else if(date.isToday()){
            if(date.hoursAfterDate(now) < 12 && date.hoursAfterDate(now) > 0){
                return "\(date.hoursAfterDate(now)) Hours"
            }
            else if(date.minutesAfterDate(now) < 60 && date.minutesAfterDate(now) > 0){
                return "\(date.minutesAfterDate(now)) Minutes"
            }
            else if(date.secondsAfterDate(now) < 60 && date.secondsAfterDate(now) > 0){
                return "\(date.secondsAfterDate(now)) Seconds"
            }        }
        
        return "\(date.daysAfterDate(now)) Days"
        
    }




}
