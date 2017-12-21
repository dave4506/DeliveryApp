//
//  AddNewPackageViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

//TODO: Conform to Form Design System

enum AddNewPackageAlert {
    case none, invalidNumber(String), differentCarrier(String,chosen:String,guess:String), offline, proPackNotification
}

class AddNewPackageViewModel {
    
    typealias CarrierTableData = (Carrier,SimpleTableData)

    let disposeBag = DisposeBag()
    let userModel = UserModel()
    let userSettingsModel = UserSettingsModel()
    
    let trackingPackageNumberVar = Variable<String>("")
    let carrierVar = Variable<Carrier>(.unknown)
    let carrierOptionsVar = Variable<[CarrierTableData]>([])
    let packageTitleVar = Variable<String>("")
    let notificationStateVar = Variable<NotificationTiers>(.basic)
    
    let copyableVar = Variable<Bool>(false)
    let alertStatusVar = Variable<AddNewPackageAlert>(.none)
    let proPackStatus = Variable<Bool>(false)

    var creatable: Observable<Bool> {
        return Observable.combineLatest(self.trackingPackageNumberVar.asObservable(), self.carrierVar.asObservable(), self.packageTitleVar.asObservable(), self.notificationStateVar.asObservable(), resultSelector: { (trackingNumber,carrier,title,notificationStatus) in
            if !trackingNumber.isEmpty && carrier != .unknown {
                return true
            }
            return false
        })
    }
    
    func checkCopyable() {
        let copyString = UIPasteboard.general.string ?? ""
        if !(copyString.isEmpty) {
            self.copyableVar.value = true
        } else {
            self.copyableVar.value = false
        }
    }
    
    func copy() -> String {
        trackingPackageNumberVar.value = UIPasteboard.general.string ?? ""
        return trackingPackageNumberVar.value
    }
    
    init() {
        guessCarriers(from:"")
        
        userSettingsModel.pullObservable().subscribe(onNext: { [unowned self] (us) in
            self.proPackStatus.value = (us!.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
        }).disposed(by: disposeBag)
        
        trackingPackageNumberVar.asObservable().subscribe(onNext: { [unowned self] newText in
            if newText.isEmpty {
                self.checkCopyable()
            } else {
                self.copyableVar.value = false
            }
            self.guessCarriers(from: newText)
        }).disposed(by: disposeBag)
    }
    
    deinit {
    }
}

extension AddNewPackageViewModel {
    
    func validatePackageForm() -> Bool {
        let trackingNumber = self.trackingPackageNumberVar.value, carrier = self.carrierVar.value, guesses = CarrierHelper.guesses(from:trackingNumber)
        
        if !trackingNumber.isEmpty && carrier != .unknown && guesses.count == 0 {
            alertStatusVar.value = .invalidNumber(trackingNumber)
            return false
        }
        
        if !CarrierHelper.guess(from: trackingNumber, be: carrier) && guesses.count > 0 {
            alertStatusVar.value = .differentCarrier(trackingNumber,chosen:carrier.description,guess: guesses.first!.1.description)
            return false
        }
        return true
    }
    
    func createPackage(){
        guard let uid = self.userModel.getCurrentUser()?.uid else { return }
        let rawPackage = PackageCreate(
            uid:uid,
            trackingNumber:trackingPackageNumberVar.value.sanitizeForStorage(),
            title:packageTitleVar.value,
            carrier:carrierVar.value,
            notificationState:notificationStateVar.value
        )
        PackageModel.create(rawData: rawPackage)
    }
}

extension AddNewPackageViewModel {
    
    func guessCarriers(from input:String) {
        var carrierOptions = generateCarrierOptions()
        let guesses = CarrierHelper.guesses(from: input)
        guesses.forEach {
            carrierOptions = moveCarrierOptionToFront(carrierOptions, carrier: $0.1, with: "Other Guess")
        }
        if guesses.count != 0 {
            carrierOptions = moveCarrierOptionToFront(carrierOptions, carrier: guesses[0].1, with: "Best Guess")
            self.carrierVar.value = guesses[0].1
        } else {
            self.carrierVar.value = .unknown
        }
        carrierOptionsVar.value = carrierOptions
    }
    
    private func generateCarrierOptions() -> [CarrierTableData] {
        return iterateEnum(Carrier.self).filter {
            $0 != .unknown
            }.map {
                ($0,SimpleTableData(title:$0.description,description:""))
        }
    }
    
    private func moveCarrierOptionToFront(_ carrierOptions:[CarrierTableData],carrier: Carrier, with description:String) -> [CarrierTableData] {
        var newCarrierOptions = carrierOptions
        let carrierIndex = carrierOptions.index {
            $0.0 == carrier
        }
        newCarrierOptions.remove(at: carrierIndex!)
        newCarrierOptions.insert((carrier,SimpleTableData(title:carrier.description,description:description)), at: 0)
        return newCarrierOptions
    }
}
