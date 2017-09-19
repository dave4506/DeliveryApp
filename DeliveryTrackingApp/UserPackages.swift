//
//  UserPackages.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/16/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct UserPackages:RawData {
    let currentPackages:[Package]
    let archivedPackages:[Package]
}

typealias PackageKey = String
typealias PackageKeys = [PackageKey]
