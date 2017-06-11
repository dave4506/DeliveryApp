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

struct CarrierSimpleData {
    var simpleTableData:SimpleTableData!
    var carrier:Carrier!
}

class AddNewPackageViewModel {
    
    let notificationOptions:[NotificationOptionStatus] = [
        NotificationOptionStatus(description:"You will not hear from us about this package.",label:"Nothing",notification:.none),
        NotificationOptionStatus(description:"We will inform you when its devlivered, off to you, and any delays.",label:"Just the basics",notification:.basic),
        NotificationOptionStatus(description:"Everything will be sent to you. This package will not escape your watchful eye!",label:"Urgent",notification:.everything)
    ]
    
    let notificationOptionDefaultIndex = 1;
    var userModel:UserModel? = nil
    let disposeBag = DisposeBag()
    let trackingPackageNumber = Variable<String>("")
    let copyBoardTrackingPackageNumber = Variable<String>("")
    let carrier = Variable<Carrier>(.unknown)
    let guessCarrier = Variable<Carrier>(.unknown)
    let defaultCarrierOptions = Variable<[CarrierSimpleData]>([])
    var carrierOptions = Variable<[CarrierSimpleData]>([])
    let packageTitle = Variable<String>("")
    let notificationStatus = Variable<NotificationStatus>(.basic)
    let copyable = BehaviorSubject<Bool>(value: false)
    let viewControllerState = BehaviorSubject<State>(value: .empty)
    
    var creatable: Observable<Bool> {
        return Observable.combineLatest(self.trackingPackageNumber.asObservable(), self.carrier.asObservable(), self.packageTitle.asObservable(), self.notificationStatus.asObservable(), resultSelector: { (trackingNumber,carrier,title,notificationStatus) in
            print("tracking number: \(trackingNumber) carrier: \(carrier) title: \(title) notify: \(notificationStatus)")
            if !trackingNumber.isEmpty && carrier != .unknown {
                return true
            }
            return false
        })
    }
    
    var createStatus = Variable<UserInterfaceStatus>(UserInterfaceStatus(networkStatus:.uninitiated,modalContent:nil))
    
    func checkCopyable() {
        let copyString = UIPasteboard.general.string ?? ""
        if !(copyString.isEmpty) {
            copyable.onNext(true)
        }
    }
    
    func copy() {
        copyBoardTrackingPackageNumber.value = UIPasteboard.general.string ?? ""
        trackingPackageNumber.value = UIPasteboard.general.string ?? ""
        copyable.onNext(false)
    }
    
    init() {
        trackingPackageNumber.asObservable().subscribe(onNext: { [weak self] newText in
            if newText.isEmpty {
                self?.checkCopyable()
            } else {
                self?.copyable.onNext(false)
            }
            self?.guessCarriers(from: newText)
        }).disposed(by: disposeBag)
        generateDefaultCarrierOptions()
        carrierOptions.value = defaultCarrierOptions.value
    }
    
    deinit {

    }
}

extension AddNewPackageViewModel {
    func createPackage(){
        guard let uid = self.userModel?.getCurrentUser()?.uid else { return }
        let packageRef = Database.database().reference(withPath: "/package")
        let key = packageRef.childByAutoId().key
        let package = ["uid":uid,
                       "tracking_number":trackingPackageNumber.value,
                       "title":packageTitle.value,
                       "carrier":Carrier.convBackShippo(from: carrier.value),
                       "notification_status":notificationStatus.value.rawValue
        ]
        
        let childUpdates = [
            "/user_packages/\(uid)/\(key)":true,
            "/packages/\(key)":package
        ] as [String : Any]
        Database.database().reference().updateChildValues(childUpdates)
    }
    
    func generateDefaultCarrierOptions() {
        var defaultSimpleCarrierData:[CarrierSimpleData] = []
        for carrier in iterateEnum(Carrier.self) {
            if carrier != .unknown {
                defaultSimpleCarrierData.append(CarrierSimpleData(simpleTableData:SimpleTableData(title:carrier.description,description:""),carrier:carrier))
            }        }
        defaultCarrierOptions.value = defaultSimpleCarrierData
    }
    
    func guessCarriers(from input:String) {
        var carrierGuessessMap = Carrier.guess(from: input)
        var carrierGuesses = carrierGuessessMap.keys.sorted(by: { c1,c2 in
            return carrierGuessessMap[c1]! > carrierGuessessMap[c2]!
        })
        if carrierGuesses.count != 0 {
            self.carrier.value = carrierGuesses[0]
            carrierOptions.value = defaultCarrierOptions.value
            for (index, carrier) in carrierGuesses.reversed().enumerated() {
                switch index {
                case carrierGuesses.count - 1 :
                    moveCarrierOptionToFront(carrier: carrier, with: "Best Guess")
                default:
                    moveCarrierOptionToFront(carrier: carrier, with: "Other Guess")
                }
            }
        } else {
            self.carrier.value = .unknown
        }
    }
    
    func moveCarrierOptionToFront(carrier: Carrier, with description:String) {
        var orgCarrierIndex = 0
        var carrierOptions = self.carrierOptions.value
        loop:
        for (index, carrierOption) in carrierOptions.enumerated() {
            if carrierOption.carrier == carrier {
                orgCarrierIndex = index
                break loop
            }
        }
        carrierOptions.remove(at: orgCarrierIndex)
        carrierOptions.insert(CarrierSimpleData(simpleTableData:SimpleTableData(title:carrier.description,description:description),carrier:carrier), at: 0)
        self.carrierOptions.value = carrierOptions
    }
}
