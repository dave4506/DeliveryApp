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
 
    let disposeBag = DisposeBag()
    var package:Package
    
    let prettyPackageVar = Variable<PackageDetailsViewModelLoadingState>(.unintiated)
    let trackingHistoryVar = Variable<[TrackingLocationHistory]>([])
    
    init(_ p:Package) {
        package = p
    }

    func clearPackage() {
        //package = nil
        prettyPackageVar.value = .unintiated
        trackingHistoryVar.value = []
    }
    
    func pullPackage() {
        Package.pull(id: package.id).takeWhile({ $0 != nil }).flatMap { [unowned self] prettyPackage -> Observable<PrettyPackage> in
            self.updateCacheReadTime(package: prettyPackage?.package)
            self.prettyPackageVar.value = .loadingNotrail(prettyPackage:prettyPackage!)
            self.trackingHistoryVar.value = prettyPackage?.trackingTimeline?.reversed() ?? []
            return Trail.generateMapTrails(dict: (prettyPackage?.package?.trackingDetailsDict)!).flatMap{ trail -> Observable<PrettyPackage> in
                var newPrettypackage = prettyPackage
                newPrettypackage?.trail = trail
                return Observable<PrettyPackage>.just(newPrettypackage!)
            }
        }.subscribe(onNext: { [unowned self] package in
            self.trackingHistoryVar.value = package.trackingTimeline?.reversed() ?? []
            if let _ = package.trail {
                self.prettyPackageVar.value = .complete(prettyPackage:package)
            } else {
                self.prettyPackageVar.value = .loadingNotrail(prettyPackage:package)
            }
        }, onError: { [unowned self] error in
            self.prettyPackageVar.value = .error(error)
        }).addDisposableTo(disposeBag)
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
    
    func updateCacheReadTime(package:Package?) {
        guard let p = package else { return }
        guard let dict = p.trackingDetailsDict else { return }
        guard let dateUpdated = dict["date_updated"] else { return }
        Database.database().reference(withPath: "/packages/\(p.id)/cache_read_time").setValue(dateUpdated)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if let _ = delegate.notificationModel.notificationIndictorStatuses[p.id] {
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1
        }
        delegate.notificationModel.notificationIndictorStatuses.removeValue(forKey: p.id)
    }
}
