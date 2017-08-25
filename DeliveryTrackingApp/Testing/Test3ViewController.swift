//
//  Test3ViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Test3ViewController: UITableViewController {
    
    @IBOutlet weak var test2: DetailDropDownContent!
    @IBOutlet weak var testCell: UITableViewCell!
    @IBOutlet weak var test: SelectorContent!
    @IBOutlet weak var optionCell: UITableViewCell!
    @IBOutlet weak var packageView: PackageTableView!
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var centerLinkContent: CenterLinkContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        
        centerLinkContent.linkTitle = "CLICK ME"
        tableView.delegate = self
        
        optionCell.layoutIfNeeded()
        optionCell.updateConstraintsIfNeeded()
        test.tableView = tableView
        test.indexPath = IndexPath(row: 6, section: 0)
        test.selections = MockCarriers
        test2.tableView = tableView
        test2.indexPath = IndexPath(row: 7, section: 0)
        test2.selections = MockCarriers
        /*
        packageView.state = .loading
        packageView.tableView = tableView
        packageView.indexPath = IndexPath(row: 8, section: 0)
        let testObservable = Observable.just([PrettyPackage](repeating:PrettyPackage(),count:5))
        testObservable.bindTo(packageView.packagesView.rx.items(cellIdentifier: "empty", cellType: EmptyPackageCell.self)) { [weak self] (row, element, cell) in
            cell.startAnimation(delay: TimeInterval(row))
            self?.packageView.setHeightOfList()
            }.addDisposableTo(disposeBag)
        let testObservable = Observable.just([PrettyPackage](repeating:MockPackages.one,count:5))
        testObservable.bindTo(packageView.packagesView.rx.items(cellIdentifier: "package", cellType: PackageTableViewCell.self)) { [weak self] (row, element, cell) in
            cell.package = element
            self?.packageView.setHeightOfList()
            }.addDisposableTo(disposeBag)
        let testObservable = Observable.just([PrettyPackage](repeating:PrettyPackage(),count:5))
        testObservable.bindTo(packageView.packagesView.rx.items(cellIdentifier: "empty", cellType: EmptyPackageCell.self)) { [weak self] (row, element, cell) in
            cell.startAnimation(delay: TimeInterval(row))
            self?.packageView.setHeightOfList()
            }.addDisposableTo(disposeBag)
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func configureNavButton() {
        var image = Assets.logo.upArrow
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
}
