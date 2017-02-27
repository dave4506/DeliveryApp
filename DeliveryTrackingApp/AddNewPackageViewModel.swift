//
//  AddNewPackageViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

class AddNewPackageViewModel {
    
    let shippoModel = ShippoTest()
    
    
    
    func trackNewPackage(trackingCode: String, carrier: String, nameOfPackage: String, notification: Int) -> Bool{
        
        return shippoModel.trackPackage(trackingCode: trackingCode, carrierCall: carrier, name: nameOfPackage, notification: notification)
        
        
    }
    
    
    
    

    

}
