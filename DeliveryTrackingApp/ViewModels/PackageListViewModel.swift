//
//  PackageListViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/5/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//
import Foundation
import RxSwift
import Firebase

class PackageListViewModel:ListViewModel,ListViewPullable {
    
    let dateTextVar = Variable<String>("Your Updates")
    let statsVar = Variable<Statistics>(Statistics(awaiting:0,delivered:0,traveling:0))
    
    override init() {
        super.init()
    }
    
    deinit {

    }
    
    func pullPackages() {
        super.pullPackages(filterPred: { $0.package!.archived == false }, onNext: generateStatistics(_:))
        setDateText()
    }
}


extension PackageListViewModel {
    
    func setDateText() {
        let hour = Date().component(.hour)
        if let hour = hour {
            if hour < 12 {
                dateTextVar.value = "Your Morning Updates"
            }
            if hour >= 12 && hour < 20 {
                dateTextVar.value = "Your Afternoon Updates"
            }
            if hour >= 20 && hour <= 24 {
                dateTextVar.value = "Your Evening Updates"
            }
        }
    }
    
    func generateStatistics(_ packages:[PrettyPackage]) {
        var awaiting = 0, traveling = 0, delivered = 0;
        packages.forEach {
            switch $0.status! {
            case .delivered:
                delivered += 1;break;
            case .error, .outForDelivery, .traveling, .delay:
                traveling += 1
            case .awaiting, .unknown:
                awaiting += 1;break;
            }
        }
        let stats = Statistics(awaiting: awaiting, delivered: delivered, traveling: traveling)
        self.statsVar.value = stats
    }
}
