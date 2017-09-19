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

class SplitViewModel {
    
    let disposeBag = DisposeBag()
    let userPackagesModel = UserPackagesModel()
    let userSettingsModel = UserSettingsModel()
        
    let firstTimeVar = Variable<Bool>(false)
    var packageCountVar = Variable<Int>(0)
    let proPackStatus = Variable<Bool>(false)
    
    func checkFirstTime() {
        userSettingsModel.pullObservable().subscribe(onNext: { [unowned self] settings in
            if let firstTime = settings?.firstTime {
                self.firstTimeVar.value = firstTime
            } else {
                self.firstTimeVar.value = true
            }
        }).addDisposableTo(disposeBag)
    }
    
    init() {
        userPackagesModel.watch()
        userPackagesModel.packageKeysVar.asObservable().subscribe(onNext: { [unowned self] (keys) in
            self.packageCountVar.value = keys.count
        }).disposed(by: disposeBag)
        userSettingsModel.pullObservable().subscribe(onNext: { [unowned self] in
            self.proPackStatus.value = ($0!.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
        }).disposed(by: disposeBag)
    }

}
