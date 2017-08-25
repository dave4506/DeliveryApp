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
import AssistantKit
import ESPullToRefresh

class PackageListViewController: ListTableViewController {

    @IBOutlet weak var bigPictureContent: BigPictureContent!
    @IBOutlet weak var titleLabelContent: TitleLabelContent!
    @IBOutlet weak var packageTableViewCell: UITableViewCell!
    @IBOutlet weak var packageTableView: PackageTableView!
    @IBOutlet var listTableView: ListTableView!
    
    var packageViewModel:PackageListViewModel {
        get { return self.viewModel as! PackageListViewModel }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setRowMinCount(packageTableView: packageTableView, cell: packageTableViewCell)
        updateTableView()
        bindViewModel()
        configureRefreshControls(listTableView:listTableView)
    }
    
    func bindViewModel() {
        viewModel = PackageListViewModel()
        bindViewModel(packageTableView: packageTableView, titleLabelContent: titleLabelContent)
        packageViewModel.setDateText()
        packageViewModel.dateTextVar.asObservable().subscribe(onNext: { [weak self] text in
            self?.titleLabelContent.titleLabel.text = text
        }).disposed(by:disposeBag)
        packageViewModel.statsVar.asObservable().subscribe(onNext: { [weak self] stats in
            self?.bigPictureContent.statsView.stats = stats
        }).disposed(by:disposeBag)
    }
}
