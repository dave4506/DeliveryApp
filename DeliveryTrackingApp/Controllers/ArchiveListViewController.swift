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

class ArchiveListViewController: ListTableViewController {

    @IBOutlet weak var titleLabelContent: TitleLabelContent!
    @IBOutlet weak var packageTableViewCell: UITableViewCell!
    @IBOutlet weak var packageTableView: PackageTableView!
    @IBOutlet weak var listTableView: ListTableView!
    
    var archiveViewModel:ArchiveListViewModel {
        get { return self.viewModel as! ArchiveListViewModel }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRowMinCount(packageTableView: packageTableView, cell: packageTableViewCell)
        updateTableView()
        bindViewModel()
        configureVisualComponents()
    }
    
    func bindViewModel() {
        viewModel = ArchiveListViewModel()
        bindViewModel(packageTableView: packageTableView, titleLabelContent: titleLabelContent) { [unowned self] status in
            switch status {
            case .empty:
                self.titleLabelContent.refreshState = .stop
                self.packageTableView.setHeightToDefault()
                if !self.viewModel!.proPackStatus.value {
                    return [.state(status:Statuses.archiveProPack)];
                } else {
                    return [.state(status:Statuses.empty)];
                }
            default: return nil;
            }
        }
    }
    
    func configureVisualComponents() {
        self.titleLabelContent.titleLabel.text = "Your Archived Packages"
    }
}
