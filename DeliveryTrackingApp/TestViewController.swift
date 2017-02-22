//
//  TestViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/10/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var focusedMapView: FocusedMapView!
    @IBOutlet weak var bigPictureView: BigPictureView!
    @IBOutlet weak var onboardCardWrapper: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientView = GradientView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(gradientView)
        focusedMapView.trails = [MockTrails.one,MockTrails.two]
        focusedMapView.focusedIndex = 0
        bigPictureView.unfocusedStatistics = Statistics(awaiting:3, delivered: 1, traveling: 1)
        bigPictureView.focusedPackage = MockPackages.one
        bigPictureView.focusedState = true;
        onboardCardWrapper.addSubview(generateOnboardCards(frame:CGRect(origin:.zero,size:onboardCardWrapper.bounds.size))[1])
        
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
