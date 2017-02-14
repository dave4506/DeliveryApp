//
//  Map.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct Position {
    let long:Double?
    let lat:Double?
}

struct Trail {
    let currentPosition:Position?
    let destination:Position?
    let path:[Position]?
}
