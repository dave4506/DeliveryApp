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

class AddPackageViewController: UITableViewController {

    var listView:ListTableView?
    var doneButton:PrimaryButton?
    
    let disposeBag = DisposeBag()
    var viewModel: AddNewPackageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        configureTableView()
        generatePrimaryButton()
        
        configureViewModels()
        bindVisualComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func configureViewModels() {
        self.viewModel = AddNewPackageViewModel()
    }
    
    func bindVisualComponents() {
        
    }
    
    func configureTableView() {
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        tableView.backgroundView = gradientView
        tableView.delegate = self
        listView = tableView as! ListTableView?
        listView?.setSectionHeader(height: 20)
        listView?.setSectionFooter(height: 100)
    }
    
    func configureNavButton() {
        var image = Assets.logo.cross.gray
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }

    func generatePrimaryButton() {
        doneButton = PrimaryButton()
        doneButton?.setTitle("START TRACKING",for:.normal)
        self.navigationController?.view.addSubview(doneButton!)
        setButtonViewContraints(view:doneButton!,parent:(self.navigationController?.view)!)
    }
    
    func setButtonViewContraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -20)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 50)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: -50)
        let horizontalConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,horizontalConstraint,bottomConstraint,heightConstraint])
        view.layoutIfNeeded()
    }
}
