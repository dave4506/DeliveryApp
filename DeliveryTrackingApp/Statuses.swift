//
//  Statuses.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct MockStatuses {
    static let error = PrettyStatus(
        title:"Hmmmm...",
        icon:Assets.logo.package.open,
        description:"This is sweet",
        caption:"Hmmmm cool stuff",
        actionable:false,
        buttonTitle:nil
    )
}
