//
//  PackageListViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/5/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//
import Foundation
import RxSwift

class ArchiveListViewModel:ListViewModel,ListViewPullable {
    
    override init() {
    }
    
    deinit {
        
    }
    
    func pullPackages() {
        super.pullPackages(filterPred: { $0.package!.archived == true }, onNext: nil)
    }
}
