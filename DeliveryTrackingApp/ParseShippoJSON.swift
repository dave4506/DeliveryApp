//
//  ParseShippoJSON.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import SwiftyJSON


class ParseShippoJSON {
    
    
    func parseJSON(json: JSON) -> String{
        
        let carrier = json["carrier"].string
        
        return carrier!
    
    }


}
