//
//  Package.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/20/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct Package {
    
    var tracking_number: String
    
    var carrier: String
    

}
extension Package {
    
    init(number: String, carrierCall:String){
        
        tracking_number = number
        
        carrier = carrierCall
        
    }
    


}
