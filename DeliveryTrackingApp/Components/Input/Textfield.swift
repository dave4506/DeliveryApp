//
//  Textfield.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/11/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class Textfield: UITextField {

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        self.font = UIFont(name: Assets.typeFace.regular, size: 16)
        self.borderStyle = .none
        self.layer.cornerRadius = 0;
        self.textColor = Color.tertiary
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                               attributes: [NSForegroundColorAttributeName: Color.secondary])
        self.tintColor = Color.primary
        self.backgroundColor = UIColor.clear
    }
    
}
