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
        let attributedString = NSMutableAttributedString(string: (self.title ?? "").uppercased() )
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Assets.typeFace.regular, size: 16)!, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: Color.tertiary, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(2), range: NSRange(location: 0, length: attributedString.length))
        
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        self.titleView = titleLabel
    }
    
}
