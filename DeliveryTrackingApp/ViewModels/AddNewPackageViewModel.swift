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

typealias CarrierTableData = (Carrier,SimpleTableData)

enum AddNewPackageAlert {
    case none, invalidNumber(String), differentCarrier(String,chosen:String,guess:String), offline, proPackNotification
}

class AddNewPackageViewModel {
    
    let notificationOptionDefaultIndex = 1;
    var userModel:UserModel
    let disposeBag = DisposeBag()
    let trackingPackageNumberVar = Variable<String>("")
    let copyBoardTrackingPackageNumberVar = Variable<String>("")
    let carrierVar = Variable<Carrier>(.unknown)
    let guessCarrierVar = Variable<Carrier>(.unknown)
    var defaultCarrierOptions:[CarrierTableData] = []
    var carrierOptionsVar = Variable<[CarrierTableData]>([])
    let packageTitleVar = Variable<String>("")
    let notificationStatusVar = Variable<NotificationStatus>(.basic)
    let copyableVar = Variable<Bool>(false)
    let alertStatusVar = Variable<AddNewPackageAlert>(.none)
    var proPackStatus = Variable<Bool>(false)

    var creatable: Observable<Bool> {
        return Observable.combineLatest(self.trackingPackageNumberVar.asObservable(), self.carrierVar.asObservable(), self.packageTitleVar.asObservable(), self.notificationStatusVar.asObservable(), resultSelector: { (trackingNumber,carrier,title,notificationStatus) in
            if !trackingNumber.isEmpty && carrier != .unknown {
                return true
            }
            return false
        })
    }
    
    func checkCopyable() {
        let copyString = UIPasteboard.general.string ?? ""
        if !(copyString.isEmpty) {
            copyableVar.value = true
        } else {
            copyableVar.value = false
        }
    }
    
    func copy() {
        copyBoardTrackingPackageNumberVar.value = UIPasteboard.general.string ?? ""
        trackingPackageNumberVar.value = UIPasteboard.general.string ?? ""
    }
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        userModel = delegate.userModel!
        trackingPackageNumberVar.asObservable().subscribe(onNext: { [weak self] newText in
            if newText.isEmpty {
                self?.checkCopyable()
            } else {
                self?.copyableVar.value = false
            }
            self?.guessCarriers(from: newText)
        }).disposed(by: disposeBag)
        generateDefaultCarrierOptions()
        carrierOptionsVar.value = defaultCarrierOptions
        userModel.userSettingsVar.asObservable().subscribe(onNext: { [unowned self] in
            self.proPackStatus.value = ($0.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
        }).disposed(by: disposeBag)
    }
    
    deinit {
    }
}

extension AddNewPackageViewModel {
    
    func validatePackageForm() -> Bool {
        let trackingNumber = self.trackingPackageNumberVar.value
        let carrier = self.carrierVar.value
        let guesses = Carrier.guess(from: trackingNumber)
        if !trackingNumber.isEmpty && carrier != .unknown && guesses.count == 0 {
            alertStatusVar.value = .invalidNumber(trackingNumber)
            return false
        }
        let guessedSame = guesses.contains {
            return $0.1 == carrier
        }
        if !guessedSame && guesses.count > 0 {
            alertStatusVar.value = .differentCarrier(trackingNumber,chosen:carrier.description,guess: guesses.first!.1.description)
            return false
        }
        return true
    }

    func testForProPack() -> Bool {
        return proPackStatus.value || notificationStatusVar.value == .none
    }
    
    func createPackage(){
        guard let uid = self.userModel.getCurrentUser()?.uid else { return }
        let packageRef = Database.database().reference(withPath: "/package")
        let key = packageRef.childByAutoId().key
        let trackingNumber = trackingPackageNumberVar.value.sanitizeForStorage()
        let package = ["uid":uid,
                       "tracking_number":trackingNumber,
                       "title":packageTitleVar.value,
                       "carrier":Carrier.convert(from: carrierVar.value),
                       "notification_status":notificationStatusVar.value.rawValue,
                       "archived":false
                       ] as [String : Any]
        
        let childUpdates = [
            "/user_packages/\(uid)/\(key)":["archived":false],
            "/packages/\(key)":package,
            "cache/\(key)/": [
                "latest":["offline":"no_cache"],"date_updated":0,"uid":uid]
        ] as [String : Any]
        Database.database().reference().updateChildValues(childUpdates)
    }
    
    func generateDefaultCarrierOptions() {
        defaultCarrierOptions = iterateEnum(Carrier.self).filter {
            $0 != .unknown
        }.map {
            ($0,SimpleTableData(title:$0.description,description:""))
        }
    }
    
    func guessCarriers(from input:String) {
        let sortedGuess = Carrier.guess(from: input).sorted(by: { c1,c2 in
            return c1.0 > c2.0
        })
        sortedGuess.forEach {
            moveCarrierOptionToFront(carrier: $0.1, with: "Other Guess")
        }
        if sortedGuess.count != 0 {
            moveCarrierOptionToFront(carrier: sortedGuess.reduce(sortedGuess[0], { $0.0 > $1.0 ? $0:$1 }).1, with: "Best Guess")
            self.carrierVar.value = sortedGuess[0].1
        } else {
            self.carrierVar.value = .unknown
        }
    }
    
    func moveCarrierOptionToFront(carrier: Carrier, with description:String) {
        var carrierOptions = carrierOptionsVar.value
        let carrierIndex = carrierOptions.index {
            $0.0 == carrier
        }
        carrierOptions.remove(at: carrierIndex!)
        carrierOptions.insert((carrier,SimpleTableData(title:carrier.description,description:description)), at: 0)
        carrierOptionsVar.value = carrierOptions
    }
}
