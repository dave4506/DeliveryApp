//
//  StatsView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MapControls: UIView {
    
    @IBOutlet weak var recenterButton: UIButton!
    @IBOutlet var view: UIView!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "MapControls", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        recenterButton.imageView?.contentMode = .scaleAspectFit
        recenterButton.imageEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);

    }
}
