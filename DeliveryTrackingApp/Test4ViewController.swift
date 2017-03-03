//
//  Test4ViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/27/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import CNPPopupController

class Test4ViewController: UITableViewController {

    var popupController:CNPPopupController?
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentModal()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func presentModal() {
        let popupController = generateModal(with: Statuses.networkError)
        self.popupController = popupController
        popupController.present(animated: true)
    }
}
