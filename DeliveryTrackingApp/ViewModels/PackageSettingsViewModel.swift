//
//  PackageSettingsViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/9/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class PackageSettingsViewModel {
    
    let prettyPackage:PrettyPackage
    let userSettingsModel = UserSettingsModel()
    let packageModel:PackageModel
    let disposeBag = DisposeBag()
    let proPackStatus = Variable<Bool>(false)
    let titleInputVar = Variable<String>("")
    let notificationInputVar = Variable<NotificationTiers>(.basic)
    let archivedInputVar = Variable<Bool>(false)
    let formObservable:Observable<(String,NotificationTiers,Bool)>
    
    let saveableVar:Observable<Bool>

    init(_ rawPrettyPackage:PrettyPackage) {
        prettyPackage = rawPrettyPackage
        packageModel = PackageModel(id: prettyPackage.id)
        formObservable = Observable.combineLatest(titleInputVar.asObservable(),notificationInputVar.asObservable(),archivedInputVar.asObservable())
        
        self.titleInputVar.value = prettyPackage.title ?? ""
        self.archivedInputVar.value = prettyPackage.package.archived
        self.notificationInputVar.value = prettyPackage.package.notificationState
        
        saveableVar = formObservable.map { (t,n,a) -> Bool in
            return t != rawPrettyPackage.title || n != rawPrettyPackage.package.notificationState || a != rawPrettyPackage.package.archived
        }

        userSettingsModel.pullObservable().subscribe(onNext: { [unowned self] in
            guard let us = $0 else { return }
            self.proPackStatus.value = (us.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
        }).disposed(by: disposeBag)
    }
    
    func deletePackage() {
        packageModel.delete()
    }
    
    func updatePackage() {
        var changes:[PackageChange] = []
        if prettyPackage.title != titleInputVar.value {
            changes.append(.title(titleInputVar.value))
        }
        if prettyPackage.package.notificationState != notificationInputVar.value {
            changes.append(.notificationState(notificationInputVar.value))
        }
        if prettyPackage.package.archived != archivedInputVar.value {
            changes.append(.archived(archivedInputVar.value))
        }
        packageModel.change(changes:changes);
    }
    
    func showArchiveWarning() -> Bool {
        return prettyPackage.status != .delivered && !archivedInputVar.value
    }
}
