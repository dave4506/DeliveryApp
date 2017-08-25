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
        trackingNumber:"9999909123213213",
        carrier:"USPS",
        status:.traveling(daysLeft: 1), statusDate: Date(),
        statusLocation: nil,
        package: Package(id:"1233415436909876743",trackingNumber:"9999909123213213",carrier:.usps,title:"Nike Shoes",status:.unknown,trackingDetailsDict:nil,notificationStatus:.basic,archived:false, cacheReadTimeStamp: nil),
        trail: nil,
        trackingTimeline: nil,
        durationPercentage: 0.5, read: false
    )
}

var PackageTitles = [
    "New Books",
    "Some cool stuff",
    "Moar Stuff",
    "New Computer"
]
