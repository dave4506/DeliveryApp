//
//  Map.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import CoreLocation

struct Position {
    let lat:Double?
    let long:Double?
    func convertToCLLocationCordinate2d() -> CLLocationCoordinate2D? {
        guard let long = long, let lat = lat else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

struct Trail {
    let currentPosition:Position?
    let destination:Position?
    let path:[Position]?
}
