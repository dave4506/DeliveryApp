//
//  StateModal.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit
import CNPPopupController

func generatePopUpTheme() -> CNPPopupTheme {
    let theme = CNPPopupTheme.default()
    theme.cornerRadius = 10
    theme.popupStyle = .centered
    theme.dismissesOppositeDirection = true
    theme.maxPopupWidth = UIScreen.main.bounds.width
    theme.animationDuration = 0.3
    return theme
}

func generateModal(with state:PrettyStatus) -> CNPPopupController {
    let stateCard = StateCard(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width*0.8, height: 300)))
    stateCard.status = state
    let popupController = CNPPopupController(contents:[stateCard])
    popupController.theme = generatePopUpTheme()
    return popupController
}
