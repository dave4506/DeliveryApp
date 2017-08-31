//
//  PackageSettingsViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/9/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import Firebase

class SplitViewModel {
    
    let firstTimeVar = Variable<Bool>(false)
    let disposeBag = DisposeBag()
    var userModel:UserModel
    var packageListCountRef:DatabaseReference?
    var packageListCountHandle:DatabaseHandle?
    var packageCountVar = Variable<Int>(0)
    let proPackStatus = Variable<Bool>(false)
    
    func checkFirstTime() {
        userModel.getUserSettings().asObservable().subscribe(onNext: { [unowned self] settings in
            if let firstTime = settings?.firstTime {
                self.firstTimeVar.value = firstTime
            } else {
                self.firstTimeVar.value = true
            }
        }).addDisposableTo(disposeBag)
    }
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        userModel = delegate.userModel!
        observePackageListCount()
        userModel.userSettingsVar.asObservable().subscribe(onNext: { [unowned self] in
            self.proPackStatus.value = ($0.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
        }).disposed(by: disposeBag)
    }
    
    func observePackageListCount() {
        guard let uid = userModel.getCurrentUser()?.uid else { return }
        packageListCountRef = Database.database().reference(withPath: "/user_packages/\(uid)/")
        packageListCountHandle = packageListCountRef?.observe(.value, with: { [unowned self] snap in
            if let packages = snap.value as? [String:AnyObject] {
                self.packageCountVar.value = Array(packages.keys).count
            }
        })
    }
    
    func stopListen() {
        guard let handle = packageListCountHandle else { return }
        packageListCountRef?.removeObserver(withHandle: handle)
    }
    
    deinit {
        stopListen()
    }
}
