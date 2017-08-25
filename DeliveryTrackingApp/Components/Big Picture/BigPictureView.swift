//
//  BigPictureView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class BigPictureView: UIView {

    var focusedState = false
    
    var stats: Statistics?
    
    var package: PrettyPackage?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    func configureFocusedStateView() {
        self.subviews.forEach { $0.removeFromSuperview() }
        if focusedState {
            let packageView = PackageCellContent(frame:CGRect(origin:.zero,size:self.bounds.size))
            packageView.package = package
            self.addSubview(packageView)
        } else {
            let statsView = StatsView(frame:CGRect(origin:.zero,size:self.bounds.size))
            statsView.stats = stats
            self.addSubview(statsView)
        }
    }
}
