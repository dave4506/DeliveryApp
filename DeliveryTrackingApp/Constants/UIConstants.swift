//
//  UIConstants.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/9/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit

enum FontFocus : Int {
    case prominent = 1
    case standard = 2
    case muted = 3
}

struct Color {
    static let primary = UIColor(red:1.0, green:0.5, blue:0.42, alpha:1.0)
    static let secondary = UIColor(red:0.69, green:0.78, blue:0.8, alpha:1.0)
    // Potential remove of this color
    static let tertiary = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)
    static let accent = UIColor(red:0.6, green:0.84, blue:0.94, alpha:1.0)
    static let success = UIColor(red:0.0, green:0.67, blue:0.54, alpha:1.0)
    static let error = UIColor(red:1.0, green:0.25, blue:0.34, alpha:1.0)
    static let background = UIColor(red:0.95, green:0.96, blue:0.96, alpha:1.0)
}

struct FontSize {
    static let caption = 12;
    static let body = 14;
    static let title = 16;
}

struct Assets {
    struct typeFace {
        static let bold = "Montserrat-Bold"
        static let regular = "Montserrat-Regular"
    }
    struct onboard {
        static let defaultMap = #imageLiteral(resourceName: "defaultMap")
        static let people = #imageLiteral(resourceName: "onboardPeople")
        static let bigPicture = #imageLiteral(resourceName: "onboardBigPicture")
        static let details = #imageLiteral(resourceName: "onboardDetails")
    }
    static let background = #imageLiteral(resourceName: "gradientBackground")
    static let confetti = #imageLiteral(resourceName: "Confetti")
    struct logo {
        struct marker {
            static let startMarker = #imageLiteral(resourceName: "StartMarker")
            static let endMarker = #imageLiteral(resourceName: "Marker")
        }
        struct add {
            static let gray = #imageLiteral(resourceName: "addGray")
            static let white = #imageLiteral(resourceName: "addWhite")
        }
        struct check {
            static let gray = #imageLiteral(resourceName: "checkGray")
            static let green = #imageLiteral(resourceName: "checkGreen")
        }
        struct cross {
            static let gray = #imageLiteral(resourceName: "crossGray")
            static let red = #imageLiteral(resourceName: "crossRed")
        }
        static let box = #imageLiteral(resourceName: "white_box")
        static let recenter = #imageLiteral(resourceName: "recenter")
        static let dot = #imageLiteral(resourceName: "dot")
        static let down = #imageLiteral(resourceName: "down")
        static let error = #imageLiteral(resourceName: "error")
        static let leftArrow = #imageLiteral(resourceName: "left")
        static let menu = #imageLiteral(resourceName: "menu")
        static let settings = #imageLiteral(resourceName: "Settings")
        struct package {
            static let closed = #imageLiteral(resourceName: "package")
            static let open = #imageLiteral(resourceName: "packageOpen")
        }
        static let label = #imageLiteral(resourceName: "printed")
        static let refresh = #imageLiteral(resourceName: "refresh")
        struct rightArrow {
            static let gray = #imageLiteral(resourceName: "rightArrowGray")
            static let blue = #imageLiteral(resourceName: "rightArrowBlue")
            static let yellow = #imageLiteral(resourceName: "delay")
        }
        static let upArrow = #imageLiteral(resourceName: "up")
    }
}

let privacyViewModel = TextViewModel(title: "Privacy Policy", description: "Shipmnt is a labor of love that started half a year ago. With countless hours of development, design the app has been released. Along the way, I had the privilege to get help from some great peers and family members.")

let eulaViewModel = TextViewModel(title: "End User Agreement", description: "Shipmnt is a labor of love that started half a year ago. With countless hours of development, design the app has been released. Along the way, I had the privilege to get help from some great peers and family members.")

let creditViewModel = TextViewModel(title: "Credits", description: "Shipmnt is a labor of love that started half a year ago. With countless hours of development, design the app has been released. Along the way, I had the privilege to get help from some great peers and family members.")

let notificationOptions:[NotificationOptionStatus] = [
    NotificationOptionStatus(description:"You will not recieve any notifications from us about this package.",label:"Nothing",notification:.none),
    NotificationOptionStatus(description:"You will be informed when its devlivered, out for delivery, delayed, and picked up by carrier.",label:"Just the basics",notification:.basic),
    NotificationOptionStatus(description:"All shipping updates will be sent to you. This package will not escape your watchful eye!",label:"Urgent",notification:.everything)
]
