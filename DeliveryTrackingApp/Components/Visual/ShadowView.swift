//
//  ShadowView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/11/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        self.layer.shadowColor = Color.tertiary.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 30
        self.layer.shadowOffset = CGSize(width:0,height:10)
    }
}
