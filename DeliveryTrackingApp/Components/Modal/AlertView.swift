//
//  AlertView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/19/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Presentr

let statusViewPresenter: Presentr = {
    let width = ModalSize.full
    let height = ModalSize.custom(size: 64)
    let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
    let customType = PresentationType.custom(width: width, height: height, center: center)
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .coverVerticalFromTop
    customPresenter.dismissTransitionType = .coverVerticalFromTop
    customPresenter.backgroundOpacity = 0.2
    customPresenter.roundCorners = false
    customPresenter.dismissOnSwipe = true
    customPresenter.dismissOnSwipeDirection = .top
    
    return customPresenter
}()

let alertViewPresenter: Presentr = {
    let presenter = Presentr(presentationType: .dynamic(center: .center))
    presenter.transitionType = TransitionType.coverVertical
    presenter.dismissOnSwipe = false
    presenter.cornerRadius = 10.0
    presenter.roundCorners = true
    return presenter
}()

func alertDefault(vc:UIViewController,alertViewStatus:AlertViewStatus,actionOne:CustomAlertAction?,actionTwo:CustomAlertAction?) {
    let alertController = generateAlertViewController(title:alertViewStatus.title,body:alertViewStatus.description)
    let cancelAction = CustomAlertAction(title: "NO, SORRY!", style: .cancel) { alert in
        print("CANCEL!!")
    }
    let okAction = CustomAlertAction(title: "DO IT!", style: .destructive) { alert in
        print("OK!!")
    }
    alertController.addAction(actionOne ?? cancelAction)
    if let actionTwo = actionTwo {
        alertController.addAction(actionTwo)
    }
    vc.customPresentViewController(alertViewPresenter, viewController: alertController, animated: true, completion: nil)
}

func generateAlertViewController(title:String,body:String) -> CustomAlertViewController {
    let alertController = CustomAlertViewController()
    alertController.titleText = title
    alertController.bodyText = body
    return alertController
}

func generateStatusAlerViewController(description:String) -> StatusAlertViewController {
    let alertController = StatusAlertViewController()
    alertController.descriptionText = description
    return alertController
}
