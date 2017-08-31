//
//  AddPackageViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AssistantKit
import Presentr

class TextViewController: FormTableViewController {
    
    @IBOutlet var listTableView: ListTableView!
    @IBOutlet weak var titleLabelContent: TitleLabelContent!
    @IBOutlet weak var textCellContent: TextcellContent!
    
    var viewModel:TextViewModel?
    
    enum TextPush {
        case asyncDismiss,dismissSuccess(String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        configureTableView()
        configureVisualComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureVisualComponents() {
        guard let viewModel = self.viewModel else { return }
        titleLabelContent.titleLabel.text = viewModel.title
        textCellContent.bodyLabel.text = viewModel.description
        textCellContent.tableview = self.tableView
    }
    
    func push(_ p:TextPush) {
        switch p {
        case let .dismissSuccess(s):
            self.dismiss(animated: true, completion: { _ in
                ProgressHUDStatus.showAndDismiss(.success(text: s))
            });break;
        case .asyncDismiss:
            DispatchQueue.main.async() { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            };break;
        }
    }
}
