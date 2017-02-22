//
//  ShippoTest.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/20/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ShippoTest{

    let shippoTestToken = "shippo_test_132b542f0d6c88e143ab41d6b5a024d35248d117"
    
    var json:JSON!
    
    let parseShippoDataObject = ParseShippoJSON()
    
    enum ShippoData {
        case sucessDataGrab
        case error
    }
    
    
    func checkTrackingData(trackingCode: String, carrierCall: String) -> ShippoData{
       
        var dataGood:Bool!
        
        let credentialData = shippoTestToken.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        
        let headersP = [
            "Authorization: ShippoToken": "Basic \(base64Credentials)",
            "Content-Type": "application/json"
        ]
    
        Alamofire.request("https://api.goshippo.com/tracks/\(carrierCall)/\(trackingCode)", headers: headersP).responseJSON { response in
            
            switch response.result {
            case .success( _):
                dataGood = true
            case .failure( _):
                dataGood = false
            }
            
        }
        if dataGood! {
            
            return ShippoData.sucessDataGrab
        }
        else {
            
            return ShippoData.error
        }
        
    }
    
    func trackPackage(trackingCode: String, carrierCall: String){
    
        let credentialData = shippoTestToken.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        
        let headersP = [
            "Authorization: ShippoToken": "Basic \(base64Credentials)",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request("https://api.goshippo.com/tracks/\(carrierCall)/\(trackingCode)", headers: headersP).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                print("\(self.json)")
            case .failure(let error):
                print(error)
            }
        }

    }
    
    
    


}
