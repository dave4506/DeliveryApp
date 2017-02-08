//
//  ParseEasypostDatat.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import SwiftyJSON
import AFDateHelper

class ParseEasypostData{
    
    let dateModifierObject = DateModifier()
    
    var trackingID:String?
    var trackingCode:String?
    var statusMessage:String?
    var updatedAtTime:String?
    var estDeliveryDate:String?
    var carrier:String?
    var trackingDetailsArray:Array<JSON>?
    var carrierDetails:Dictionary<String, Any> = Dictionary<String, Any>()
    var publicURL:String?
    
    let json:JSON;
    
    var finalDictionary:Dictionary<String, Any> = Dictionary<String, Any>()
    

    init(jsonP: JSON){
        //needs to know if we are trying to create a tracking object or update a tracking object!!!!!
        
        json = jsonP
    }
    
    
    
    
    
    func setInitialValueForTrackingObject(){
        
        setEstDeliveryDate()
        setTrackingCode()
        setStatusMessage()
        setUpdatedTime()
        setCarrier()
        setPublicURL()
        setTrackingDetails()
        setCarrierDetails()
        
        putValuesInFinalDictionary()
    
 
    }
    
    func putValuesInFinalDictionary(){
        
        finalDictionary["tracking_id"] = trackingID
        finalDictionary["tracking_code"] = trackingCode
        finalDictionary["status"] = getSimplifiedStatusMessage(estDate: estDeliveryDate!, statusMessage: statusMessage!)
        finalDictionary["last_updated_at"] = "Updated: \(dateModifierObject.getDaysLeft(estDate: updatedAtTime!)) Ago"
        finalDictionary["est_delivery_date"] = Date(fromString: estDeliveryDate!, format: .custom("yyyy-MM-dd'T'HH:mm:ssZ")).toString()
        finalDictionary["tracking_details"] = trackingDetailsArray
        finalDictionary["carrier_details"] = carrierDetails
        finalDictionary["public_url"] = publicURL
        
        print(finalDictionary.debugDescription)
    }
    
    
    func getSimplifiedStatusMessage(estDate: String, statusMessage: String) -> String{
        let dateModifierObject = DateModifier()
        
        switch statusMessage {
        case "unknown":
            return "Unknown"
        case "pre_transit",
             "in_transit", "out_for_delivery":
            return (dateModifierObject.getDaysLeft(estDate: estDate))
        case "delivered":
            return "Delivered"
        case "available_for_pickup":
            return "Ready for Pickup"
        case "return_to_sender":
            return "Returned"
        case "failure" , "error", "Not Available":
            return "Error"
        case "cancelled":
            return "Cancelled"
        default:
            return "Error"
        }
        
    }
    
    func tryGettingTrackingID() -> Bool{
        

        if String(json["trackers"][0]["id"].stringValue) != nil {return true}
        else{return false}
        
    }
    func setTrackingID() -> String{
        if(tryGettingTrackingID()){trackingID = json["trackers"][0]["id"].stringValue}
        else{trackingID = "Not Available"}
        
        return trackingID!
    }
    
    func tryGettingTrackingCode() -> Bool{
        if String(json["trackers"][0]["tracking_code"].stringValue) != nil {return true}
        else{return false}
    }
    
    func setTrackingCode() -> String{
        if(tryGettingTrackingCode()){trackingCode = json["trackers"][0]["tracking_code"].stringValue}
        else{trackingCode = "Not Available"}
        
        return trackingCode!
    }
    func tryGettingStatusMessage() -> Bool{
        if String(json["trackers"][0]["status"].stringValue) != nil {return true}
        else{return false}
        
    }
    func setStatusMessage() -> String{
        if(tryGettingStatusMessage()){statusMessage = json["trackers"][0]["status"].stringValue}
        else{statusMessage = "Not Available"}
        
        return statusMessage!
    }
    
    func tryGettingUpdatedAtTime() -> Bool{
        if String(json["trackers"][0]["update_at"].stringValue) != nil {return true}
        else{return false}
        
    }
    func setUpdatedTime()-> String{
        if(tryGettingUpdatedAtTime()){updatedAtTime = json["trackers"][0]["updated_at"].stringValue}
        else{updatedAtTime = "Not Available"}
        
        return updatedAtTime!
    }
    
    func tryGettingEstDeliveryDate() -> Bool{
        if String(json["trackers"][0]["est_delivery_date"].stringValue) != nil {return true}
        else{return false}
        
    }
    func setEstDeliveryDate()-> String{
        if(tryGettingEstDeliveryDate()){estDeliveryDate = json["trackers"][0]["est_delivery_date"].stringValue}
        else{estDeliveryDate = "Not Available"}
        
        return estDeliveryDate!
    }
    func tryGettingCarrier() -> Bool{
        if String(json["trackers"][0]["carrier"].stringValue) != nil {return true}
        else{return false}
        
    }
    func setCarrier()-> String{
        if(tryGettingCarrier()){carrier = json["trackers"][0]["carrier"].stringValue}
        else{carrier = "Not Available"}
        
        return carrier!
    }
    
    func tryGettingPublicURL() -> Bool{
        if String(json["trackers"][0]["public_url"].stringValue) != nil {return true}
        else{return false}
        
    }
    func setPublicURL()->String{
        if(tryGettingPublicURL()){publicURL = json["trackers"][0]["public_url"].stringValue}
        else{publicURL = "Not Available"}
        
        return publicURL!
    }
    
    //if there is no trackingdetails then array will return nil
    func setTrackingDetails()-> String{
        if json["trackers"][0]["tracking_details"].arrayValue.count != 0 {
            trackingDetailsArray = json["trackers"][0]["tracking_details"].arrayValue
        }
        return trackingDetailsArray.debugDescription
        
    }
    //if there is no carrierDeatils then the Dic will return nil
    func setCarrierDetails()-> String{
        if(String(json["trackers"][0]["carrier_detail"]["origin_location"].stringValue) != nil){
            
            carrierDetails.updateValue(json["trackers"][0]["carrier_detail"]["origin_location"].stringValue, forKey: "origin_location")
        }
        if(String(json["trackers"][0]["carrier_detail"]["destination_location"].stringValue) != nil){
            carrierDetails.updateValue(json["trackers"][0]["carrier_detail"]["destination_location"].stringValue, forKey: "destination_location")
        }
       return carrierDetails.debugDescription
    }







}
