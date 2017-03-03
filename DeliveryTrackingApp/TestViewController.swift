//
//  TestViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/10/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import CNPPopupController

class TestViewController: UIViewController {

    //@IBOutlet weak var focusedMapView: FocusedMapView!
   // @IBOutlet weak var bigPictureView: BigPictureView!
    @IBOutlet weak var sideways: SidewaysSelector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientView = GradientView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(gradientView)
        //focusedMapView.trails = [MockTrails.one,MockTrails.two]
        //focusedMapView.focusedIndex = 0
        //bigPictureView.unfocusedStatistics = Statistics(awaiting:3, delivered: 1, traveling: 1)
        //bigPictureView.focusedPackage = MockPackages.one
       // bigPictureView.focusedState = true;
        sideways.selections = PackageTitles
        sideways.isStaticWidth = false
        sideways.padding = 15
        sideways.defaultIndex = 2
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func linkTapped(_ sender: Any) {
        print("here?")
    }
}
