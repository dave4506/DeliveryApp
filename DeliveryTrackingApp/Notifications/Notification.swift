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
    
    func updateUser(_ user:User,with token: String) -> Observable<String> {
        let firebaseRef = Database.database().reference(withPath: "/notification")
        return Observable.create { observer in
            firebaseRef.child(user.uid).child(token).child("created").setValue(ServerValue.timestamp())
            observer.onNext("\(token) saved locally at: \(Date())")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func pushToDetailVC(window:UIWindow?,packageId:String) {
        let packageDetailsNav = UIStoryboard(name: "PackageDetails", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        let packageDetails = packageDetailsNav.viewControllers[0] as! PackageDetailsViewController
        Package.pullPackageDetails(id: packageId).subscribe(onNext:{ [weak self] packDict in
            let viewModel = PackageDetailsViewModel(Package.convPackageDictionary(packDict!))
            packageDetails.viewModel = viewModel
            let splitViewController = window?.rootViewController as? RootSplitViewController
            packageDetails.isCollapsed = splitViewController?.isCollapsed
            splitViewController?.showDetailViewController(packageDetailsNav, sender: nil)
        }).addDisposableTo(disposeBag)
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
    
}
