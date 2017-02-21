//
//  Package.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/20/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct Package {

    var locationArray: [Dictionary<String, Any>] //country , state, city, latitutde, longitude
    
    var package_name: String
    
    var tracking_number: String
    
    var carrier: String
    
    var current_status: String // 6 Days, Delivered, etc.
    
    var isDelivered: Bool

}
extension Package {
    
    func creatPackage(){
    
    
    }
    


}
