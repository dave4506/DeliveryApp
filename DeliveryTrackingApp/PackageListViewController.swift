//
//  PackageListViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PackageListViewController: UITableViewController {

    @IBOutlet weak var bigPictureContent: BigPictureContent!
    @IBOutlet weak var titleLabelContent: TitleLabelContent!
    @IBOutlet weak var packageTableViewCell: UITableViewCell!
    @IBOutlet weak var packageTableView: PackageTableView!
    @IBOutlet var listTableView: ListTableView!
    
    var viewModel:PackageListViewModel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        bindViewModel()
        listTableView.setSectionFooter(height: 30)
        packageTableView.tableView = tableView
        //generateNavBarOpacity()
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func bindViewModel() {
        viewModel = PackageListViewModel()
        viewModel.userModel = UserModel()
        viewModel.firebaseListen()
        viewModel.setDateText()
        packageTableView.bindPackageTableView(observable:viewModel.packages.asObservable().map { p -> [PackageListViewCellData] in
            switch p {
            case .error: return [.state(status:Statuses.error)];
            case .loading: return Array(count: 10, elementCreator:PackageListViewCellData.empty);
            case let .complete(packages): return packages.map { PackageListViewCellData.package(package: $0) }
            case .empty: return [.state(status:Statuses.empty)];
            default: return [.state(status:Statuses.empty)];
            }
        }.map { return [PackageTableViewSectionData(header:"",items:$0)] },disposeBy:viewModel.disposeBag)
        viewModel.dateText.asObservable().subscribe(onNext: { [weak self] text in
            self?.titleLabelContent.titleLabel.text = text
        }).disposed(by:viewModel.disposeBag)
        viewModel.stats.asObservable().subscribe(onNext: { [weak self] stats in
            self?.bigPictureContent.statsView.stats = stats
        }).disposed(by:viewModel.disposeBag)
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
