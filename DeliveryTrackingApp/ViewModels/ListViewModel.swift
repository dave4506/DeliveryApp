//
//  ListViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/24/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

enum PackageListType {
    case archived, current
}

enum PackageListState:State {
    case unintiated, empty, loading, complete(packages:[PrettyPackage]), loadingPackages(packages:[PrettyPackage]), error(Error)
}

typealias  ListViewPullableModel = ListViewModelProtocol & ListViewPullable

protocol ListViewPullable {
    func pullPackages() -> Void
}

protocol ListViewModelProtocol {
    var packageUpdateStringVar: Variable<String> { get }
    var packagesVar: Variable<PackageListState> { get }
    var proPackStatus: Variable<Bool> { get }
    func packageClicked(indexPath:IndexPath) -> PrettyPackage?
    func generateDateString() -> Void
    func createLoadingState() -> Void
    func pullPackages(type:PackageListType,onNext:(([PrettyPackage])->Void)?) -> Void
}

class ListViewModel:ListViewModelProtocol {

    let disposeBag = DisposeBag()
    let userSettingsModel = UserSettingsModel()
    let userModel = UserModel()
    let userPackagesModel = UserPackagesModel()

    let packagesVar = Variable<PackageListState>(.loading)
    let packageUpdateStringVar = Variable<String>("")
    var packageLastUpdate:Date?
    let proPackStatus = Variable<Bool>(false)

    init() {
        recoverLastSavedDate()
        userSettingsModel.pullObservable().subscribe(onNext: { [unowned self] settings in
            self.proPackStatus.value = (settings!.purchases ?? []).contains(IAPIdentifiers.proPack.rawValue)
        }).disposed(by: disposeBag)
        DelegateHelper.connectionObservable().subscribe(onNext: { [unowned self] _ in
            self.generateDateString()
        }).disposed(by: disposeBag)
        userPackagesModel.watch()
        userPackagesModel.packageKeysVar.asObservable().subscribe(onNext: { [unowned self] (keys) in
            guard let vm = self as? ListViewPullable else { return }
            vm.pullPackages()
        }).disposed(by: disposeBag)
    }
    
    func packageClicked(indexPath:IndexPath) -> PrettyPackage? {
        if case .loadingPackages(let rowPackages) = packagesVar.value {
            return rowPackages[indexPath.row]
        }
        if case .complete(let rowPackages) = packagesVar.value {
            return rowPackages[indexPath.row]
        }
        return nil
    }
    
    func generateDateString() {
        // Possible point of issue with the first load bug
        guard let packageLastUpdate = self.packageLastUpdate else { return }
        if DelegateHelper.connectionState() == .connected {
            packageUpdateStringVar.value = "Updated " + packageLastUpdate.toStringWithRelativeTime()
        } else {
            packageUpdateStringVar.value = "Offline"
        }
    }
    
    func createLoadingState() {
        switch packagesVar.value {
        case .empty: packagesVar.value = .empty; break;
        case let .complete(p): packagesVar.value = .loadingPackages(packages: p); break;
        default: packagesVar.value = .loading;break;
        }
    }
    
    func pullPackages(type:PackageListType,onNext:(([PrettyPackage])->Void)?) {
        guard (userModel.getCurrentUser()?.uid) != nil else { return }
        createLoadingState()
        userPackagesModel.pullObservable().map {
            return $0!
        }.map { (up) -> [Package] in
            switch type {
            case .archived: return up.currentPackages
            case .current: return up.archivedPackages
            }
        }.map { (p) -> [PrettyPackage] in
            return p.map { PrettyPackage.prettify(data: $0) }
        }.map {
            return $0.sorted { (p1,p2) in
                return p1.statusDate > p2.statusDate
            }
        }.subscribe(onNext: { [unowned self] packages in
            self.packagesVar.value = packages.isEmpty ? .empty:.complete(packages:packages)
            onNext?(packages)
            self.packageLastUpdate = Date()
            self.generateDateString()
            self.saveLastSavedDate()
        },onError:    { [unowned self] (error) in
            print("ListViewModel Error: \(error)")
            self.packagesVar.value = .error(error)
        }).disposed(by: disposeBag)
    }
}

extension ListViewModel {
    func saveLastSavedDate() {
        guard let packageLastUpdate = self.packageLastUpdate else { return }
        let defaults = UserDefaults.standard
        defaults.set(packageLastUpdate.toString(format: .isoDateTimeSec), forKey: "packageLastUpdate")
    }
    
    func recoverLastSavedDate() {
        let defaults = UserDefaults.standard
        if let str = defaults.object(forKey: "packageLastUpdate") as? String {
            packageLastUpdate = Date.init(fromString: str, format: .isoDateTimeSec)
            self.generateDateString()
        }
    }
}
