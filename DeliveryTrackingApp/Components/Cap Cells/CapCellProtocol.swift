//
//  CapCellProtocol.swift
//  DeliveryTrackingApp
//
//  Created by David Sun on 11/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

enum CapCellContentPosition {
    case top, bottom, middle, topCap, bottomCap
}

protocol CapCell {
    var position:CapCellContentPosition { get set }
}

protocol  CapCellContent {
    func setVisuals(to position:CapCellContentPosition)
}
