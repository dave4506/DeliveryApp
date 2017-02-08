//
//  InitializeEasypostAPIKey.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import EasyPostApi

class InitializeEasypostAPIKey {
    
    let apiKeyProduction = "LPEbKQg5SyIh9a3GumGVMg" //Prod key
    
    func setAndCheckAPIKeys(){
        
        
        EasyPostApi.sharedInstance.setCredentials(apiKeyProduction, baseUrl: "https://api.easypost.com/v2/")
        EasyPostApi.sharedInstance.getUserApiKeys({ (result) -> () in
            switch(result) {
            case .failure(let error):
                print("Error getting user api keys: \((error as NSError).localizedDescription)")
            
                
            case .success( _):
                print("Easypost API KEY ACCEPTED.")
                
                
            }
        })        
    }

}
