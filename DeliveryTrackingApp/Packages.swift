//
//  Packages.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct MockPackages {
    static let one = PrettyPackage(
        title:"Nike Shoes",
        id:"1233415436909876743",
        trackingId:"9999909123213213",
        carrier:"USPS",
        daysLeft:1,
        prettyStatus:"1 day",
        status:.traveling
    )
}

var PackageTitles = [
    "New Books",
    "Some cool stuff",
    "Moar Stuff",
    "New Computer"
]
