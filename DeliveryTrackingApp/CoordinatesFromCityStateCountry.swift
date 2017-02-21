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

    func getCoords(address: String){
        
        //var address = "1 Infinite Loop, CA, USA"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            let placemark = placemarks?[0]
            print(placemark?.location!.coordinate.latitude ?? Double())
            print(placemark?.location!.coordinate.longitude ?? Double())
        })
    
    }

}
