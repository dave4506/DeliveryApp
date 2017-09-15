//
//  Status.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

struct Statuses {
    static let networkError = PrettyStatus(
        title:"HMM... CANT GET IT",
        icon:Assets.logo.cross.red,
        description:"We can't connect to the internet. Try a different wifi or go to a place with service",
        caption:nil,
        actionable:false,
        buttonTitle:nil
    )
    static let empty = PrettyStatus(
        title:"*** CRICKETS ***",
        icon:Assets.logo.package.open,
        description:"Looks like there is nothing coming your way.",
        caption:"P.S. that orange button looks interesting",
        actionable:false,
        buttonTitle:nil
    )
    static let error = PrettyStatus(
        title:"WE ALL MAKE MISTAKES",
        icon:Assets.logo.cross.red,
        description:"Bummer. Something didn't work out. Let's try that again.",
        caption:nil,
        actionable:false,
        buttonTitle:nil
    )
    static let archiveProPack = PrettyStatus(
        title:"Upgrade To ProPack",
        icon:Assets.logo.package.open,
        description:"With ProPack, you can archive packages to keep them for later use instead of deleting them.",
        caption:nil,
        actionable:false,
        buttonTitle:nil
    )
}

struct AlertView {
    static let archiveConfirmation = AlertViewStatus(title: "Are you sure?", description: "The package is still on it's way. You will not recieve any notifications if archived.")
    static let deleteConfirmation = AlertViewStatus(title: "Are you sure?", description: "There is no take backs. Consider your final words.")
    static let deleteDisabledWarning = AlertViewStatus(title: "App is Offline", description: "You can't delete a package when the app is offline.")
    static let offlineNotificationWarning = AlertViewStatus(title: "App is offline", description: "You can save new notification options, but it will not come into effect until the app is back online.")
    static let invalidTrackingNumberWarning =  { (id:String) -> AlertViewStatus in
        AlertViewStatus(title: "Can't quite make it out.", description: "The tracking number \(id) doesn't appear to come from a carrier we support. Double check the tracking number, but if you think its right, continue with the chosen carrier.")
    }
    static let conflictCarrierWarning = { (id:String,guess:String,chosen:String) -> AlertViewStatus in
        AlertViewStatus(title: "Are you sure?", description: "We determined for the tracking number \(id) the correct carrier is \(guess). You selected \(chosen). If you are sure that the carrier chosen is correct, continue.")
    }
    static let offlineWarning = AlertViewStatus(title: "App is Offline", description: "We are stranded on an internetless island! 🏝 You can still add packages, but we can't update you on the package's status until you are online again.")
    static let proPackPackageLimitWarning = AlertViewStatus(title: "Upgrade to Pro Pack", description: "Free Users are limited to 3 packages. Delete some packages to add more or upgrade to pro pack in the settings!")
    static let proPackArchiveWarning = AlertViewStatus(title: "Upgrade to Pro Pack", description: "Free Users are not allowed to archive their packages. Upgrade to pro pack in the settings!")
    static let proPackNotificationWarning = AlertViewStatus(title: "Upgrade to Pro Pack", description: "Free Users are limited to the 'none' notfication tier. Upgrade to pro pack in the settings to unlock all other notification settings!")
}
