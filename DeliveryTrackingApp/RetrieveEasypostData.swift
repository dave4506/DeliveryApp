//
//  RetrieveEasypostData.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Alamofire
import EasyPostApi
import SwiftyJSON

class RetrieveEasypostData {
    
    let apiTestKey = "yhXNkjUa2P7OAHNLL5mHAA" //prodKey
    
    
    func createTrackerObjectWithTrackingCode(trackingCode: String, carrierCall: String) {
        
        let credentialData = apiTestKey.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        
        let headersP = [
            "Authorization": "Basic \(base64Credentials)",
            "Content-Type": "application/json"
        ]
        let params = [
            "tracking_code": trackingCode,
            "carrier": carrierCall
        ]
        Alamofire.request("https://api.easypost.com/v2/trackers", parameters: params, headers: headersP).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print("Validation Successful")
                let json = JSON(value)
                //print("\(json)")
                self.sendToParseEasypostDataClass(jsonS: json)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    func updateTrackingObjectWithTrackingID(trackID: String) {
        
        let credentialData = apiTestKey.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headersP = [
            "Authorization": "Basic \(base64Credentials)",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request("https://api.easypost.com/v2/trackers/\(trackID)", headers: headersP).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print("Validation Successful")
                let json = JSON(value)
                self.sendToParseEasypostDataClass(jsonS: json)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    func sendToParseEasypostDataClass(jsonS: JSON){
        let parseEasypostData = ParseEasypostData(jsonP: jsonS)
        
        parseEasypostData.setInitialValueForTrackingObject()
    }

    
    


}
