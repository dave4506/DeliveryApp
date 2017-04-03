//
//  BigPictureViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class BigPictureViewController: UIViewController {

    @IBOutlet weak var navItem: ClearNavigationItem!
    @IBOutlet weak var sidewaysSelector: SidewaysSelector!
    @IBOutlet weak var focusedMapView: FocusedMapView!
    @IBOutlet weak var mapWrapperView: ShadowView!
    @IBOutlet weak var bigPicture: BigPictureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientView = GradientView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(gradientView)
        mapWrapperView.layer.cornerRadius = 10
        mapWrapperView.clipsToBounds = true
        configureNavButton()
        let stats = Statistics(awaiting: 0, delivered: 1, traveling: 2)
        let package = MockPackages.one
        configureBigPicture(status: true, stats: stats, package: package)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func configureNavButton() {
        var image = Assets.logo.refresh
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
    
    func configureBigPicture(status:Bool,stats:Statistics?,package:PrettyPackage?) {
        bigPicture.focusedState = status
        if status {
            bigPicture.package = package
        } else {
            bigPicture.stats = stats
        }
        bigPicture.configureFocusedStateView()
    }
}
