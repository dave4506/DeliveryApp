//
//  ClearNavigationViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/4/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class ClearNavigationViewController: UINavigationController {

    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
