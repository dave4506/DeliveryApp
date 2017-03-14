//
//  Package.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/20/17.

//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
struct PrettyPackage {
    let title:String?
    let id:String?
    let trackingId:String?
    let carrier:String?
    let daysLeft:Int?
    let prettyStatus:String?
    let status:PackageStatus?
}

enum PackageStatus {
    case awaiting,error,unknown,delivered,traveling
}

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
