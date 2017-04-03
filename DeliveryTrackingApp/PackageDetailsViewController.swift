//
//  PackageDetailsViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class TitlePackageDetailsCell: UITableViewCell {
    @IBOutlet weak var titleContent: TitleGroupWithProgressContent!
}

class DetailsPackageDetailsCell: UITableViewCell {
    @IBOutlet weak var detailContent: DetailDropDownContent!
}

enum DetailCellIdentifiers: String {
    case title
    case details
}

struct CellData {
    let identifier:DetailCellIdentifiers
    let content:AnyObject?
}

class PackageDetailsViewController: UITableViewController {

    var listView:ListTableView?
    var doneButton:PrimaryButton?
    var cellIdentifiers:[CellData] = [CellData(identifier:.title,content:nil)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        tableView.backgroundView = gradientView
        tableView.delegate = self
        tableView.dataSource = self
        listView = tableView as! ListTableView
        listView?.setSectionHeader(height: 20)
        listView?.setSectionFooter(height: 100)
        generatePrimaryButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = cellIdentifiers[indexPath.row]
        let identifier = cellData.identifier
        switch identifier {
        case .title:
            let cell: TitlePackageDetailsCell! = tableView.dequeueReusableCell(withIdentifier: identifier.rawValue) as? TitlePackageDetailsCell
            return cell;
        case .details:
            let cell: DetailsPackageDetailsCell! = tableView.dequeueReusableCell(withIdentifier: identifier.rawValue) as? DetailsPackageDetailsCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func configureNavButton() {
        var image = Assets.logo.leftArrow
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
    
    func generatePrimaryButton() {
        doneButton = PrimaryButton()
        doneButton?.setTitle("SAVE CHANGES",for:.normal)
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
