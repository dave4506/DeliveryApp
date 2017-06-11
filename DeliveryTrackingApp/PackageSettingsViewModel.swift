//
//  PackageSettingsViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/9/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
//
//  AddNewPackageViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import Firebase

struct Changes {
    var notification:NotificationStatus!
    var title:String?
    var id:String
    var archived:Bool!
}

enum PackageSettingPrettyChangeState {
    case unintiated, complete(changes:Changes), setByPackage(changes:Changes)
}

enum PackageSettingPrettyPackageState {
    case unintiated, complete(prettyPackage:PrettyPackage)
}

class PackageSettingsViewModel {
    
    let notificationOptions:[NotificationOptionStatus] = [
        NotificationOptionStatus(description:"You will not hear from us about this package.",label:"Nothing",notification:.none),
        NotificationOptionStatus(description:"We will inform you when its devlivered, off to you, and any delays.",label:"Just the basics",notification:.basic),
        NotificationOptionStatus(description:"Everything will be sent to you. This package will not escape your watchful eye!",label:"Urgent",notification:.everything)
    ]
    
    let notificationOptionDefaultIndex = 1;
    var userModel:UserModel? = nil
    let disposeBag = DisposeBag()
    let prettyPackage = Variable<PackageSettingPrettyPackageState>(.unintiated)
    let changes = Variable<PackageSettingPrettyChangeState>(.unintiated)
    var saveable:Observable<Bool>!
    init() {
        saveable = Observable.combineLatest(prettyPackage.asObservable(), changes.asObservable()) { (p,c) -> Bool in
            switch (p, c) {
            case let (.complete(a),.complete(b)), let (.complete(a),.setByPackage(b)):
                return (a.package!.notificationStatus != b.notification || a.title != b.title || a.package!.archived != b.archived)
            default: return false
            }
        }
        
        prettyPackage.asObservable().subscribe(onNext:{ [weak self] prettyPackageStatus in
            switch prettyPackageStatus {
            case let .complete(prettyPackage):
                self?.changes.value = .setByPackage(changes: Changes(notification: (prettyPackage.package?.notificationStatus)!, title: prettyPackage.title, id: prettyPackage.id,archived: (prettyPackage.package?.archived)!))
                break;
            default: break;
            }
        }).disposed(by: disposeBag)
    }
    
    deinit {
    }
    
    func savePackage(){
        guard let uid = self.userModel?.getCurrentUser()?.uid else { return }
        switch self.changes.value {
        case let .complete(a):
            let key = a.id
            let childUpdates = [
                "/packages/\(key)/notification_status":a.notification.rawValue,
                "/packages/\(key)/archived":a.archived,
                "/packages/\(key)/title":a.title
                ] as [String : Any]
            Database.database().reference().updateChildValues(childUpdates)
        default:break;
        }
    }
}
