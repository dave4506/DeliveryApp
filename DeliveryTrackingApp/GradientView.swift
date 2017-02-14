//
//  GradientView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/11/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        let gradientImageViewer = UIImageView(image: Assets.background)
        gradientImageViewer.contentMode = .scaleAspectFill
        gradientImageViewer.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientImageViewer.clipsToBounds = true;
        self.addSubview(gradientImageViewer)
        self.layer.zPosition = -1
    }
    
}
