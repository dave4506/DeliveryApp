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

enum PackageDetailsState:State {
    case unintiated, loading, error(Error), loadingNotrail(prettyPackage:PrettyPackage), complete(prettyPackage:PrettyPackage)
}

class PackageDetailsViewModel {
 
    let disposeBag = DisposeBag()
    var packageModel:PackageModel
    
    let prettyPackageVar = Variable<PackageDetailsState>(.unintiated)
    let trackingHistoryVar = Variable<[LocationTrackingHistory]>([])
    
    init(_ p:Package) {
        self.packageModel = PackageModel(id:p.id)
    }
    
    init(_ p:PrettyPackage) {
        self.packageModel = PackageModel(id:p.id)
        self.prettyPackageVar.value = .loadingNotrail(prettyPackage: p)
        self.trackingHistoryVar.value = p.trackingTimeline?.reversed() ?? []
    }
    
    func pullPackage() {
        self.packageModel.pullObservable().takeWhile({ $0 != nil }).map { return PrettyPackage.prettify(data: $0!) }.flatMap { [unowned self] prettyPackage -> Observable<PrettyPackage> in
            self.updateCacheReadTime(package: prettyPackage.package)
            self.prettyPackageVar.value = .loadingNotrail(prettyPackage:prettyPackage)
            self.trackingHistoryVar.value = prettyPackage.trackingTimeline?.reversed() ?? []
            guard prettyPackage.package.type == .valid else { return Observable<PrettyPackage>.just(prettyPackage) }
            return Trail.convert(data: TrailLocations.convert(dict: prettyPackage.package.trackingDetailsDict!)).flatMap{ trail -> Observable<PrettyPackage> in
                var newPrettypackage = prettyPackage
                newPrettypackage.trail = trail
                return Observable<PrettyPackage>.just(newPrettypackage)
            }
        }.subscribe(onNext: { [unowned self] package in
            if let _ = package.trail {
                self.prettyPackageVar.value = .complete(prettyPackage:package)
            } else {
                self.prettyPackageVar.value = .loadingNotrail(prettyPackage:package)
                self.trackingHistoryVar.value = package.trackingTimeline?.reversed() ?? []
            }
        }, onError: { [unowned self] error in
            self.prettyPackageVar.value = .error(error)
        }).disposed(by: disposeBag)
    }
    
    func getPrettyPackage() -> PrettyPackage? {
        if case .complete(let prettyPackage) = prettyPackageVar.value {
            return prettyPackage
        }
        if case .loadingNotrail(let prettyPackage) = prettyPackageVar.value {
            return prettyPackage
        }
        return nil
    }
    
    func updateCacheReadTime(package:Package) {
        guard let dict = package.trackingDetailsDict else { return }
        guard let dateUpdated = dict["date_updated"] else { return }
        Database.database().reference(withPath: "/packages/\(package.id)/cache_read_time").setValue(dateUpdated)
        DelegateHelper.readNotification(for: package.id)
    }
}
