//
//  AddNewPackageViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class AddNewPackageViewModel {
    
    let shippoModel = ShippoTest()
    
    
    enum ValidationResult {
        case ok(message: String)
        case empty
        case validating
        case failed(message: String)
    }
    
    func trackNewPackage(trackingCode: String, carrier: String, nameOfPackage: String, notification: Int){
        
    
        self.shippoModel.trackPackage(trackingCode: trackingCode, carrierCall: carrier, name: nameOfPackage, notification: notification)
            

      
        
    }
    
    
    
    

    

}
