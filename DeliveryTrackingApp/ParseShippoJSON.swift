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
    
    
    let coordsModel = CoordinatesFromCityStateCountry()
    
    func parseJSON(json: JSON) -> Dictionary<String, Any?>{
        
        let carrier = json["carrier"].string
        
        let trackingCode = json["tracking_number"].string
        
        let eta = json["eta"].string
        
        
        
        let dictionary = ["carrier": carrier ?? String(), "tracking_number" : trackingCode ?? String(), "eta": eta ?? String(), "locations" : getLocaitonData(json: json)] as [String : Any]
        print(json)
        
        return dictionary
    
    }
    
    func getLocaitonData(json: JSON) -> [String]{
        //"1 Infinite Loop, CA, USA"
        
        var finalDictionary:[String] = []
        
        let addressFrom = "\(json["address_from"]["city"].string!), \(json["address_from"]["state"].string!), \(json["address_from"]["country"].string!)"
        
        let addressTo = "\(json["address_to"]["city"].string!), \(json["address_to"]["state"].string!), \(json["address_to"]["country"].string!)"
        
        finalDictionary.append(addressFrom)
        
        finalDictionary.append(addressTo)
        
       
        
        return finalDictionary
        
    
    }


}
