//
//  FCIMTokenDelegate.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/10/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("new token: \(fcmToken)")
        let userModel = UserModel()
        userModel.logInUserRx().flatMap { [unowned self] user in
            return self.notificationModel.updateUser(user, with: fcmToken)
        }.subscribe(onNext: { status in
            print("Token Saved. \(status)")
        }, onError: { error in
            print("FCM TOKEN ERROR: \(error)")
        }, onCompleted: nil, onDisposed: nil).disposed(by: userModel.disposeBag)
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[NotificationModel.gcmMessageIDKey] {
            print("Old Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[NotificationModel.gcmMessageIDKey] {
            print("Old Completion Message ID: \(messageID)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
        if notificationModel.determineUpdateIndicator(dict: userInfo as! [String:AnyObject]) {
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[NotificationModel.gcmMessageIDKey] {
            print("iOS 10 > Will Message ID: \(messageID)")
        }
        print(userInfo)
        if notificationModel.determineUpdateIndicator(dict: userInfo as! [String:AnyObject]) {
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        }
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[NotificationModel.gcmMessageIDKey] {
            print("iOS 10 > DId Message ID: \(messageID)")
        }
        print(userInfo)
        if notificationModel.determineUpdateIndicator(dict: userInfo as! [String:AnyObject]) {
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        }
        notificationModel.pushToDetailVC(window: self.window, packageId: userInfo["packageId"] as! String)
        completionHandler()
    }
}
