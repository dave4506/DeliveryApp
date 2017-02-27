//
//  clearNavigationBar.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class ClearNavigationItem: UINavigationItem {

    /*
     override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    
    func commonInit() {
        let titleLabel = UILabel()
        let attributedString = NSMutableAttributedString(string: self.title!.uppercased())
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Assets.typeFace.regular, size: 20)!, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.tertiary, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(2), range: NSRange(location: 0, length: attributedString.length))
        
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        self.titleView = titleLabel
    }
    
}
