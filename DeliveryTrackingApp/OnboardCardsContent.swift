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
    var title:String?
    var image:UIImage?
    var paragraph:String?
}

let onboardCardsContent = [
    OnboardCardContent(
        title:"WE ALL HAVE PACKAGE ANXIETY",
        image:Assets.onboard.people,
        paragraph:"Don’t be ashame of it. We all want that thing you have been eyeing for to come as soon as it can."
    ),
    OnboardCardContent(
        title:"TRACK AWAY",
        image:Assets.onboard.boxes,
        paragraph:"Add your package’s tracking number and feel the anxiety go away. No limits."
    ),
    OnboardCardContent(
        title:"IN A GLIMPSE",
        image:Assets.onboard.movement,
        paragraph:"See the progress of your shipments on a map. Trace the paths it has taken and guess where it will go next."
    ),
    OnboardCardContent(
        title:"AS SIMPLE AS COPY & PASTE",
        image:nil,
        paragraph:"Copy your tracking id from the receipt, and we will handle the rest."
    )
]

func generateOnboardCards(frame:CGRect) -> [OnboardCard] {
    var onboardCards:[OnboardCard] = []
    var index = 0;
    onboardCards = onboardCardsContent.map { content in
        let card = OnboardCard(frame: frame)
        card.onboardTitle.text = content.title!
        card.onboardImageView.image = content.image ?? UIImage()
        card.onboardDescription.text = content.paragraph!
        specialStyling(at: index,for: card)
        index += 1
        return card
    }
    
    return onboardCards
}

func specialStyling(at index:Int,for view:OnboardCard) {
    switch index {
    case 2:
        var mapView = UIImageView(frame: CGRect(origin:.zero,size:(view.shadowView?.bounds.size)!))
        mapView.image = Assets.onboard.defaultMap
        mapView.alpha = 1
        view.shadowView?.addSubview(mapView)
        break;
    case 3:
        //TODO: For a later date with page Control in mind
    break;
    default: break;
    }
}
