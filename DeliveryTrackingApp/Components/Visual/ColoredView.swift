//
//  ColoredView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class ColoredView: UIView {

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = Color.primary
        self.alpha = 0.1
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

}
