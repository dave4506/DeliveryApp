//
//  ListTableViewController
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AssistantKit


class ListTableViewController: UITableViewController {
    
    var viewModel:ListViewPullableModel?
    let disposeBag = DisposeBag()
    var timer: Timer?

    enum Push {
        case toDetails(package:PrettyPackage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.pullPackages()
        self.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRowMinCount(packageTableView:PackageTableView,cell:UITableViewCell) {
        packageTableView.setRowMinCount(yCord:cell.frame.origin.y,height:self.view.frame.height)
        packageTableView.tableView = tableView
    }
    
    func updateTableView() {
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func push(_ p:Push) {
        switch p {
        case let .toDetails(package):
            let packageDetailsNav = UIStoryboard(name: "PackageDetails", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
            let packageDetails = packageDetailsNav.viewControllers[0] as! PackageDetailsViewController
            let viewModel = PackageDetailsViewModel(package)
            packageDetails.viewModel = viewModel
            packageDetails.isCollapsed = self.splitViewController?.isCollapsed
            self.splitViewController?.showDetailViewController(packageDetails.navigationController!, sender: nil);break;
        }
    }
}

extension ListTableViewController {
    func bindViewModel(packageTableView:PackageTableView,titleLabelContent:TitleLabelContent,handler:((PackageListState) -> [PackageListViewCellData]?)?) {
        guard let viewModel = self.viewModel else { return }
        viewModel.pullPackages()
        packageTableView.bindPackageTableView(observable:viewModel.packagesVar.asObservable().map { [unowned self] p -> [PackageListViewCellData] in
            if let packageCells = handler?(p) {
                return packageCells
            }
            switch p {
            case .loading:
                packageTableView.setHeightToDefault()
                return Array(count: packageTableView.minCount, elementCreator:PackageListViewCellData.empty);
            case let .loadingPackages(packages):
                packageTableView.determineHeight(count: packages.count)
                titleLabelContent.refreshState = .stop
                return packages.map { PackageListViewCellData.loadingPackage(package: $0) }
            case let .complete(packages):
                packageTableView.determineHeight(count: packages.count)
                titleLabelContent.refreshState = .stop
                return packages.map { PackageListViewCellData.package(package: $0) }
            case .error:
                titleLabelContent.refreshState = .stop
                packageTableView.setHeightToDefault()
                return [.state(status:Statuses.error)];
            case .empty:
                titleLabelContent.refreshState = .stop
                packageTableView.setHeightToDefault()
                return [.state(status:Statuses.empty)];
            default: return [.state(status:Statuses.empty)];
            }
        }.map { return [PackageTableViewSectionData(header:"",items:$0)] },disposeBy:disposeBag)
        
        packageTableView.packagesView?.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            print("index clicked: \(indexPath.row)")
            if let package = viewModel.packageClicked(indexPath: indexPath) {
                print("lets give it a tap")
                self.push(.toDetails(package: package))
            }
        }).disposed(by: disposeBag)
        
        titleLabelContent.refreshButton.rx.tap.subscribe(onNext: {
            if DelegateHelper.connectionState() == .connected {
                viewModel.pullPackages()
                titleLabelContent.refreshState = .loading
            } else {
                ProgressHUDStatus.showAndDismiss(.error(text:"Can't refresh now."))
            }
        }).disposed(by: disposeBag)
        
        
        viewModel.packageUpdateStringVar.asDriver().drive(titleLabelContent.updatedLabel.rx.text).disposed(by:disposeBag)
    }
}

extension ListTableViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func runTimer() {
        self.viewModel?.generateDateString()
    }
}

extension ListTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


