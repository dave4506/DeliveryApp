//
//  PackageDetailsViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/7/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
//
//  PackageListViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/5/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire
import Firebase

enum PackageDetailsViewModelLoadingState {
    case unintiated, loading, error(Error), loadingNotrail(prettyPackage:PrettyPackage), complete(prettyPackage:PrettyPackage)
}

class PackageDetailsViewModel {
 
    var userModel:UserModel? = nil
    let disposeBag = DisposeBag()
    var package:Package? {
        didSet {
            pullPackage()
        }
    }
    
    let prettyPackage = Variable<PackageDetailsViewModelLoadingState>(.unintiated)
    let trackingHistory = Variable<[TrackingLocationHistory]>([])
    
    init() {
        
    }
    
    deinit {
        
    }
    
    func pullPackage() {
        guard let p = self.package else { return }
        prettyPackage.value = .loading
        Shippo.pullPackage(package:p).map { dict -> PrettyPackage? in
            guard let dict = dict else { return nil }
            var package = p
            package.trackingDetailsDict = dict
            return PrettyPackage.convert(package: package)
            }.flatMap { [weak self] prettyPackage -> Observable<PrettyPackage> in
                self?.prettyPackage.value = .loadingNotrail(prettyPackage:prettyPackage!)
                self?.trackingHistory.value = prettyPackage?.trackingTimeline?.reversed() ?? []
                return PrettyPackage.generateMapTrails(dict: (prettyPackage?.package?.trackingDetailsDict)!).flatMap { trail -> Observable<PrettyPackage> in
                    var newPrettypackage = prettyPackage
                    newPrettypackage?.trail = trail
                    return Observable<PrettyPackage>.just(newPrettypackage!)
                }
            }.subscribe(onNext: { [weak self] package in
                self?.trackingHistory.value = package.trackingTimeline?.reversed() ?? []
                self?.prettyPackage.value = .complete(prettyPackage:package)
        }, onError: { [weak self] error in
            self?.prettyPackage.value = .error(error)
            print("PackageDeatilsViewModel Error: \(error)")
        }).addDisposableTo(disposeBag)
    }
}

extension PackageListViewModel {
}
