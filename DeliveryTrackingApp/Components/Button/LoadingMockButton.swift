//
//  PrimaryButton.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/11/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingMockButton: UIView {
    
    let height: CGFloat = 56
    let padding: CGFloat = 16
    
    let isLoading: Bool = false
    
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: 2*padding + self.bounds.width, height: height))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.bounds.width, height: height))
    }
    
    func commonInit() {
        layoutLoading();
        layoutBackground();
    }
    
    func layoutLoading() {
        let loader = NVActivityIndicatorView(frame: CGRect(origin:CGPoint.zero, size: CGSize(width: self.bounds.width, height: height)) , type: .ballPulse, color: UIColor.white, padding: 16/2)
        self.addSubview(loader)
        loader.startAnimating()
    }
    
    
    func layoutBackground() {
        self.backgroundColor = Color.primary
        self.layer.cornerRadius = height/2
        self.layer.shadowColor = Color.primary.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 15
        self.layer.shadowOffset = CGSize(width:0,height:20)
    }
}
