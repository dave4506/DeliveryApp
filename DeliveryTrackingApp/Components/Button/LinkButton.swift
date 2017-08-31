//
//  CaptionLabel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/10/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

@IBDesignable
class LinkButton: UIButton {
    
    var customSpacing = true
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        if customSpacing {
            let attributedString = NSMutableAttributedString(string: (title?.uppercased() ?? ""))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.primary, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: attributedString.length))
            super.setAttributedTitle(attributedString, for: state)
        } else {
            super.setTitle(title, for: state)
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        //self.setTitle(self.titleLabel?.text, for: .normal)
        self.titleLabel?.font = UIFont(name: Assets.typeFace.regular, size: 14)
    }
    
}
