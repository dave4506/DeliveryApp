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
    
    let firebaseHandler = FirebaseHandler()

    
   
    func trackPackage(trackingCode: String, carrierCall: String, name: String, notification: Int) -> Bool{
        
        var checkShit = false
        
        let credentialData = shippoTestToken.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        
        let headersP = [
            "Authorization: ShippoToken": "Basic \(base64Credentials)",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request("https://api.goshippo.com/tracksl/\(carrierCall)/\(trackingCode)", headers: headersP).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                
                checkShit = self.firebaseHandler.addPackageToCurrentTackingListInFirebase(dictionary: self.parseShippoDataObject.parseJSON(json: self.json, nameOfPackage: name, notification: notification))
                
            case .failure( _):
                break
            }
        }
        
        return checkShit
        
    }
    
    
    


}
