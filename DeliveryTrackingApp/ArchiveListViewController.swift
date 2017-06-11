//
//  PackageListViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class ArchiveListViewController: UITableViewController {

    @IBOutlet weak var titleLabelContent: TitleLabelContent!
    @IBOutlet weak var packageTableViewCell: UITableViewCell!
    @IBOutlet weak var packageTableView: PackageTableView!
    @IBOutlet var listTableView: ListTableView!

    var viewModel:ArchiveListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.setSectionFooter(height: 30)
        configureNavButton()
        tableView.delegate = self
        packageTableView.tableView = tableView
        bindViewModel()
        bindVisualComponents()
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func bindViewModel() {
        viewModel = ArchiveListViewModel()
        viewModel.userModel = UserModel()
        viewModel.firebaseListen()
        packageTableView.bindPackageTableView(observable:viewModel.packages.asObservable().map { p -> [PackageListViewCellData] in
            switch p {
            case .error: return [.state(status:Statuses.error)];
            case .loading: return Array(count: 10, elementCreator:PackageListViewCellData.empty);
            case let .complete(packages): return packages.map { PackageListViewCellData.package(package: $0) }
            case .empty: return [.state(status:Statuses.empty)];
            default: return [.state(status:Statuses.empty)];
            }
            }.map { return [PackageTableViewSectionData(header:"",items:$0)] },disposeBy:viewModel.disposeBag)
    }
    
    func bindVisualComponents() {
        self.titleLabelContent.titleLabel.text = "Your Archived Packages"
    }
    
    func configureNavButton() {
        var image = Assets.logo.refresh
        image = image.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
