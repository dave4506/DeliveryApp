//
//  CoordinatesFromCityStateCountry.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/20/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import CoreLocation

class CoordinatesFromCityStateCountry {
    
    var lat:Double?
    var long:Double?

    func getCoords(address: String) -> Dictionary<String,Double>{
        
        //var address = "1 Infinite Loop, CA, USA"
        
        print(address)
        
        var coord: Dictionary<String,Double> = [:]
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            let placemark = placemarks?[0]
             self.lat = placemark?.location!.coordinate.latitude ?? Double()
             self.long = placemark?.location!.coordinate.longitude ?? Double()


        })
        
        
        coord["lat"] = self.lat
        coord["long"] = self.long
        
        return coord
        
    
    }

}
