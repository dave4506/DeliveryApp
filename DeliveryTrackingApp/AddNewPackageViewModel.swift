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
    
    
    
    func trackNewPackage(trackingCode: String, carrier: String) -> Bool{
        
        var didFindError = true
        
        var shippoDataEnum: ShippoTest.ShippoData
    
        shippoDataEnum = self.shippoModel.checkTrackingData(trackingCode: trackingCode, carrierCall: carrier)
        
        switch shippoDataEnum {
        case .sucessDataGrab:
            didFindError = false
            shippoModel.trackPackage(trackingCode: trackingCode, carrierCall: carrier)
        case .error:
            print("Error Shit")
        }
        
        return didFindError

        
    }
    
    
    
    

    

}
