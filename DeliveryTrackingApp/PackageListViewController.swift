//
//  PackageListViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class PackageListViewController: UITableViewController {

    @IBOutlet weak var archiveLink: CenterLinkContent!
    
    var fabButton: FloatingActionButton?
    var rootFabButtonOrigin: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        let mapView = UnfocusedMapView()
        gradientView.addSubview(mapView)
        generateMapConstraints(view: mapView,parent: gradientView)
        tableView.backgroundView = gradientView
        configureNavButton()
        generateFabButton(refView:mapView)
        tableView.delegate = self
        archiveLink.linkTitle = "VIEW ARCHIVE"
        print(self.tableView.contentOffset.y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavButton() {
        var image = Assets.logo.upArrow
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func generateMapConstraints(view: UIView,parent:UIView) {
        print(parent.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 210)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: -10)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: -70)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: -50)
        NSLayoutConstraint.activate([heightConstraint,topConstraint,leadingConstraint,trailingConstraint])
        view.layoutIfNeeded()
    }
    
    func generateFabButton(refView: UIView) {
        let cornerX = refView.bounds.width - 70 - 48
        let cornerY = refView.bounds.height - 10 + 5
        
        fabButton = FloatingActionButton(frame:CGRect(origin:CGPoint(x:cornerX,y:cornerY),size:CGSize(width:56,height:56)))
        rootFabButtonOrigin = fabButton?.frame.origin
        self.navigationController?.view.addSubview(fabButton!)
    }
    
    func moveFabButton() {
        let offset = self.tableView.contentOffset.y
        print("here we are? \(offset)")
        if offset < -35 && offset > -64 {
            fabButton?.frame.origin.x = (rootFabButtonOrigin?.x)! + (64 + offset) * 2.4
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        moveFabButton()
    }
}
