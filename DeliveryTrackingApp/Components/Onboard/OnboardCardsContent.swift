//
//  OnboardCardsContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit

struct OnboardCardContent {
    var title:String!
    var image:UIImage!
    var paragraph:String!
}

let onboardCardsContent = [
    OnboardCardContent(
        title:"WE ALL HAVE PACKAGE ANXIETY",
        image:Assets.onboard.people,
        paragraph:"Don’t be ashame of it. We all want that thing you have been eyeing for to come as soon as it can."
    ),
    OnboardCardContent(
        title:"In a Glimpse",
        image:Assets.onboard.bigPicture,
        paragraph:"Instantly see the status of all of your parcels. See what is on the way, delivered, or awaiting pickup by the carrier"
    ),
    OnboardCardContent(
        title:"Sensible Information",
        image:Assets.onboard.details,
        paragraph:"See only the delivery details meaningful to you. All the redundant details are tucked neatly so you see what's important."
    ),
    OnboardCardContent(
        title:"AS SIMPLE AS COPY & PASTE",
        image:nil,
        paragraph:"Copy your tracking id from the receipt, and we will handle the rest."
    )
]

func specialOnboardStyling(at index:Int,for view:OnboardCard) {
    switch index {
    case 2:
        break;
    case 3:
        //TODO: For a later date with page Control in mind
        view.onboardImageView.isHidden = true
        let fabButton = FloatingActionButton()
        view.addSubview(fabButton)
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: fabButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let widthConstraint = NSLayoutConstraint(item: fabButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let xConstraint = NSLayoutConstraint(item: fabButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: fabButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([widthConstraint,yConstraint,xConstraint,heightConstraint])
        fabButton.layoutIfNeeded()
        break;
    default: break;
    }
}
