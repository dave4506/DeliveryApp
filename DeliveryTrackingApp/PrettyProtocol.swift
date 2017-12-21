//
//  PrettyProtocols.swift
//  DeliveryTrackingApp
//
//  Created by David Sun on 9/20/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

protocol PrettyModel {
}

protocol Prettyfiable {
    associatedtype ObjectType = Self
    associatedtype Data:RawData
    static func prettify(data:Data) -> ObjectType
}
