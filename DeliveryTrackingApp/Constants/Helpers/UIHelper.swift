//
//  ListHelper.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/24/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

class AlertHelper {
    static func generateCancelAction() -> CustomAlertAction {
        return CustomAlertAction(title: "Cancel", style: .cancel,handler: nil)
    }
}
