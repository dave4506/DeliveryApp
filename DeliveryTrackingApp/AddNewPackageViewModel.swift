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

class AddNewPackageViewModel {
    let disposeBag = DisposeBag()
    
    let active = false
    let trackingPackageNumber = Variable<String>("")
    let carrier = Variable<Carrier>(.unknown)
    let packageTitle = Variable<String>("")
    let notificationStatus = Variable<NotificationStatus>(.basic)
    
    var creatable: Observable<Bool> {
        return Observable.combineLatest(self.trackingPackageNumber.asObservable(), self.carrier.asObservable(), self.packageTitle.asObservable(), self.notificationStatus.asObservable(), resultSelector: { (trackingNumber,carrier,title,notificationStatus) in
            return false
        })
    }
    
    var createStatus = Variable<UserInterfaceStatus>(UserInterfaceStatus(networkStatus:.uninitiated,modalContent:nil))
    
    init() {
        trackingPackageNumber.asObservable().subscribe(onNext: { [weak self] newText in
            self?.carrier.value = Carrier.guess(from: newText) ?? .unknown
        }).disposed(by: disposeBag)
    }
    
    
}

/*
 let shippoModel = ShippoTest()
 
 enum ValidationResult {
 case ok(message: String)
 case empty
 case validating
 case failed(message: String)
 }
 
 func trackNewPackage(trackingCode: String, carrier: String, nameOfPackage: String, notification: Int){
 self.shippoModel.trackPackage(trackingCode: trackingCode, carrierCall: carrier, name: nameOfPackage, notification: notification)
 }
 */
