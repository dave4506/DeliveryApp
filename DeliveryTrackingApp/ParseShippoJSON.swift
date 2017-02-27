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
    
    func parseJSON(json: JSON, nameOfPackage: String, notification: Int) -> Dictionary<String, Any?>{
        
        let carrier = getCarrierPrety(carier: json["carrier"].string!)
        
        let currentStatus = getSimplifiedStatusMessage(estDate: json["eta"].string!, statusMessage: json["tracking_status"]["status"].string!)
    
        let trackingCode = json["tracking_number"].string
        
        
        
        let dictionary = ["notificationCraze":notification,"currentStatus_for_PackageList": currentStatus,"name": nameOfPackage,"carrier": carrier, "tracking_number" : trackingCode ?? String(), "locations_for_MapView" : getLocaitonData(json: json)] as [String : Any]
        
        return dictionary
    
    }
    
    func getLocaitonData(json: JSON) -> [String]{
        //"1 Infinite Loop, CA, USA"
        
        var finalDictionary:[String] = []
        
        if let trackingHistoryCount:Int = json["tracking_history"].arrayValue.count {
            for i in 0 ..< trackingHistoryCount {
                let addressinTrackingHistory = "\(json["tracking_history"].arrayValue[i]["location"]["city"].string!), \(json["tracking_history"].arrayValue[i]["location"]["state"].string!), \(json["tracking_history"].arrayValue[i]["location"]["country"].string!)"
                
                finalDictionary.append(addressinTrackingHistory)

            }
        
        }
        
        
        return finalDictionary
        
    }
    
    func getPrettyDetailedArray(json: JSON){
    
    
    
    
    }
    func getCarrierPrety(carier:String) -> String{
        let carrierPrettyModel = CarrierPretty()
        
        return carrierPrettyModel.prettyCarrier(carrier: carier)
        
    }
    func getSimplifiedStatusMessage(estDate: String, statusMessage: String) -> String{
        let dateModifierObject = DateModifier()
        
        switch statusMessage {
        case "UNKNOWN":
            return "AWAITING"
        case "TRANSIT":
            return (dateModifierObject.getDaysLeft(estDate: estDate))
        case "DELIVERED":
            return "DELIVERED"
        case "RETURNED":
            return "RETURNED"
        case "FAILURE":
            return "ERROR"
        default:
            return "ERROR"
        }
        
        
    }


}
