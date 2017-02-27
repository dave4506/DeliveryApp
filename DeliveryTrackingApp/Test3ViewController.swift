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
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var centerLinkContent: CenterLinkContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
                
        centerLinkContent.linkTitle = "CLICK ME"
        //packageView.state = .empty
        /*
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

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print("called?")
        return UITableViewAutomaticDimension
    }
    
    func configureNavButton() {
        var image = Assets.logo.upArrow
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        
    }
}
