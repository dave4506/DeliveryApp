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
    }
    
    func bindViewModel() {
        viewModel = PackageListViewModel()
        bindViewModel(packageTableView: packageTableView, titleLabelContent: titleLabelContent, handler:nil)
        packageViewModel.dateTextVar.asDriver().drive(self.titleLabelContent.titleLabel.rx.text).disposed(by:disposeBag)
        packageViewModel.statsVar.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] stats in
            self?.bigPictureContent.statsView.stats = stats
        }).disposed(by:disposeBag)
        packageViewModel.setDateText()
    }
}
