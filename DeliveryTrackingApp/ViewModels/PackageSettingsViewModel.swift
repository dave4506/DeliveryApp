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

struct PackageSettingsForm {
    var notification:NotificationStatus!
    var title:String
    var id:String
    var archived:Bool!
}

enum PackageSettingPrettyChangeState {
    case unintiated, complete(form:PackageSettingsForm), setByPackage(form:PackageSettingsForm)
}

enum PackageSettingPrettyPackageState {
    case unintiated, complete(prettyPackage:PrettyPackage)
}

enum PackageSettingsChange {
    case title(String),notification(NotificationStatus),archived
}

class PackageSettingsViewModel {
    
    let userModel:UserModel
    let disposeBag = DisposeBag()
    let saveableVar:Observable<Bool>

    let notificationOptionDefaultIndex = 1;
    let prettyPackageVar = Variable<PackageSettingPrettyPackageState>(.unintiated)
    let changesVar = Variable<PackageSettingPrettyChangeState>(.unintiated)
    var proPackStatus = Variable<Bool>(false)
    
    init(_ rawPrettyPackage:PrettyPackage) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        userModel = delegate.userModel!
        saveableVar = Observable.combineLatest(prettyPackageVar.asObservable(), changesVar.asObservable()) { (p,c) -> Bool in
            switch (p, c) {
            case let (.complete(a),.complete(b)), let (.complete(a),.setByPackage(b)):
                return (a.package!.notificationStatus != b.notification || a.title != b.title || a.package!.archived != b.archived)
            default: return false
            }
        }
        prettyPackageVar.asObservable().subscribe(onNext:{ [weak self] prettyPackageStatus in
            switch prettyPackageStatus {
            case let .complete(prettyPackage):
                self?.changesVar.value = .setByPackage(form: PackageSettingsForm(notification: (prettyPackage.package?.notificationStatus)!, title: prettyPackage.title!, id: prettyPackage.id,archived: (prettyPackage.package?.archived)!))
                break;
            default: break;
            }
        }).disposed(by: disposeBag)
        prettyPackageVar.value = .complete(prettyPackage: rawPrettyPackage)
        userModel.userSettingsVar.asObservable().subscribe(onNext: { [unowned self] in
            self.proPackStatus.value = ($0.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
        }).disposed(by: disposeBag)
    }
    
    deinit {
    }
    
    func modifyChanges(_ change:PackageSettingsChange) {
        var newForm:PackageSettingsForm?
        if case let .complete(form) = changesVar.value { newForm = form }
        if case let .setByPackage(form) = changesVar.value { newForm = form }
        guard var form = newForm else { return }
        switch change {
        case .title(let s): form.title = s;break;
        case .notification(let n):form.notification = n;break;
        case .archived: form.archived = !form.archived;break;
        }
        changesVar.value = .complete(form: form)
    }
    
    func getArchive() -> Bool? {
        var newForm:PackageSettingsForm?
        if case let .complete(form) = changesVar.value { newForm = form }
        if case let .setByPackage(form) = changesVar.value { newForm = form }
        guard let form = newForm else { return nil }
        return form.archived
    }
    
    func testForProPack() -> Bool {
        return proPackStatus.value
    }
    
    func provideArchiveWarning() -> Bool {
        if case .complete(let c) = changesVar.value, case .complete(let p) = prettyPackageVar.value {
            return p.status != .delivered && !c.archived
        } else {
            return false
        }
    }
    
    func deletePackage() {
        guard let uid = userModel.getCurrentUser()?.uid else { print("no uid"); return }
        guard case .complete(let p) = prettyPackageVar.value else { print("no complete"); return }
        let key = p.id!
        let childUpdates = [
            "/packages/\(key)/":NSNull(),
            "/user_packages/\(uid)/\(key)":NSNull()
        ] as [String : Any]
        Database.database().reference().updateChildValues(childUpdates)
    }
    
    func savePackage(){
        guard  let uid = userModel.getCurrentUser()?.uid else { return }
        switch self.changesVar.value {
        case let .complete(a):
            let key = a.id
            print("saved? \(a.id)")
            let childUpdates = [
                "/packages/\(key)/notification_status":a.notification.rawValue,
                "/packages/\(key)/archived":a.archived,
                "/packages/\(key)/title":a.title,
                "/user_packages/\(uid)/\(key)/archived":a.archived
                ] as [String : Any]
            Database.database().reference().updateChildValues(childUpdates)
        default:break;
        }
    }
}
