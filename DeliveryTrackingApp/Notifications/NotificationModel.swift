//
//  NotificationModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/10/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import Firebase
import UserNotifications

struct NotificationIndicatorStatus {
    let id:String
    let read:String
}

class NotificationModel {
    
    var notificationIndictorStatuses: [String:NotificationIndicatorStatus] = [:]
    
    static let gcmMessageIDKey = "gcm.message_id"
    
    let disposeBag = DisposeBag()
    
    init() {
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
    }
    
    func pushToDetailVC(window:UIWindow?,packageId:String) {
        let packageDetailsNav = UIStoryboard(name: "PackageDetails", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        let packageDetails = packageDetailsNav.viewControllers[0] as! PackageDetailsViewController
        let packageModel = PackageModel(id: packageId)
        packageModel.pullObservable().subscribe(onNext:{ [weak self] pack in
            let viewModel = PackageDetailsViewModel(pack!)
            packageDetails.viewModel = viewModel
            let splitViewController = window?.rootViewController as? RootSplitViewController
            packageDetails.isCollapsed = (splitViewController?.isCollapsed)!
            splitViewController?.showDetailViewController(packageDetailsNav, sender: nil)
        }).addDisposableTo(disposeBag)
    }
    
    func update(_ user:User,with token: String) -> Observable<String> {
        let firebaseRef = Database.database().reference(withPath: "/notification")
        return Observable.create { observer in
            firebaseRef.child(user.uid).child(token).child("created").setValue(ServerValue.timestamp())
            observer.onNext("\(token) saved locally at: \(Date())")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func determineUpdateIndicator(dict:[String:AnyObject]) -> Bool {
        guard let read = dict["read"] as? String else { return false }
        guard let id = dict["packageId"] as? String else { return false }
        let indicatorStatus = NotificationIndicatorStatus(id:id,read:read)
        if let _ = notificationIndictorStatuses[id] {
            return false
        } else {
            notificationIndictorStatuses[id] = indicatorStatus
            return true
        }
    }
    
    static func registerForNotification() {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as! AppDelegate

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
}
