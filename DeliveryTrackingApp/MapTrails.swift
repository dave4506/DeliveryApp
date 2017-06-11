//
//  MapTrails.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct MockTrails {
    static let one = Trail(
        from:Position(lat:41.928668, long:-109.018545),
        destination:Position(lat:37.256363,long:-121.942206),
        path:[Position(lat:41.928668, long:-109.018545),
              Position(lat: 44.328017, long:-97.968496),
              Position(lat:44.012109, long:-84.549366)]
    )
    static let two = Trail(
        from:Position(lat:33.486065, long:-112.030325),
        destination:Position(lat:37.256363,long:-121.942206),
        path:[Position(lat:33.072412, long: -104.657483),
              Position(lat: 32.578696, long: -82.907102),
              Position(lat:28.563366, long: -81.816231)]
    )
}
