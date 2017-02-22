//
//  ParseShippoJSON.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import SwiftyJSON


class ParseShippoJSON {
    
    
    func parseJSON(json: JSON) -> Dictionary<String, Any?>{
        
        let carrier = json["carrier"].string
        
        let trackingCode = json["tracking_number"].string
        
        let dictionary = ["carrier": carrier, "tracking_number" : trackingCode]
        print(json)
        
        return dictionary
    
    }


}
