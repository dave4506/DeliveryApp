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

enum PackageListViewPackagesState {
    case unintiated, empty, loading, complete(packages:[PrettyPackage]), loadingPackages(packages:[PrettyPackage]), error(Error)
}

typealias  ListViewPullableModel = ListViewModelProtocol & ListViewPullable

protocol ListViewPullable {
    func pullPackages() -> Void
}

protocol ListViewModelProtocol {
    var packageUpdateStringVar: Variable<String> { get }
    var packagesVar: Variable<PackageListViewPackagesState> { get }
    func packageClicked(indexPath:IndexPath) -> Package?
    func generateDateString() -> Void
    func createLoadingState() -> Void
    func pullPackages(filterPred:@escaping (PrettyPackage)->Bool,onNext:(([PrettyPackage])->Void)?) -> Void
}

class ListViewModel:ListViewModelProtocol {

    let disposeBag = DisposeBag()
    let packagesVar = Variable<PackageListViewPackagesState>(.loading)
    let userModel:UserModel
    let packageUpdateStringVar = Variable<String>("")
    var packageLastUpdate:Date?
    var userPackagesHandler:UInt?
    var userPackagesRef:DatabaseReference?
    init() {
        userModel = UserModel()
        listenToChanges()
    }

    deinit {
        stopListen()
    }
    
    func listenToChanges() {
        guard let vm = self as? ListViewPullable else { return }
        guard let uid = userModel.getCurrentUser()?.uid else { return }
        userPackagesRef = Database.database().reference().child("user_packages").child(uid)
        userPackagesHandler = userPackagesRef!.observe(.value, with: { _ in
            vm.pullPackages()
        })
    }
    
    func stopListen() {
        guard let handler = userPackagesHandler else { return }
        userPackagesRef?.removeObserver(withHandle: handler)
    }
    
    func packageClicked(indexPath:IndexPath) -> Package? {
        if case .complete(let rowPackages) = packagesVar.value {
            return rowPackages[indexPath.row].package
        }
        return nil
    }
    
    func generateDateString() {
        guard let packageLastUpdate = self.packageLastUpdate else { return }
        packageUpdateStringVar.value = "Updated " + packageLastUpdate.toStringWithRelativeTime()
    }
    
    func createLoadingState() {
        switch packagesVar.value {
        case .empty: packagesVar.value = .empty; break;
        case let .complete(p): packagesVar.value = .loadingPackages(packages: p); break;
        default: packagesVar.value = .loading;break;
        }
    }
    
    func pullPackages(filterPred:@escaping (PrettyPackage)->Bool,onNext:(([PrettyPackage])->Void)?) {
        guard let uid = userModel.getCurrentUser()?.uid else { return }
        createLoadingState()
        Package.pullUserPackages(uid:uid).flatMap({ id -> Observable<PrettyPackage?> in
            return Package.pull(id: id) //may not be right crashable
        }).toArray().map{ packages -> [PrettyPackage] in
                let sanitized:[PrettyPackage] = packages.filter { $0 != nil }.map { return $0! }
                let regularPackages:[PrettyPackage] = sanitized.filter(filterPred)
                return regularPackages.sorted { (p1,p2) in
                    return p1.statusDate > p2.statusDate
                }
            }.subscribe(onNext: { [weak self] packages in
                if packages.isEmpty {
                    self?.packagesVar.value = .empty
                } else {
                    self?.packagesVar.value = .complete(packages:packages)
                }
                onNext?(packages)
                let delegate = UIApplication.shared.delegate as! AppDelegate
                if delegate.connectionModel?.connectionState.value == .connected {
                    self?.packageLastUpdate = Date()
                }
                self?.generateDateString()
                },onError:    { [weak self] (error) in
                    print("ListViewModel Error: \(error)")
                    self?.packagesVar.value = .error(error)
            }).disposed(by: disposeBag)
    }
}
