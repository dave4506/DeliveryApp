//
//  CaptionLabel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/10/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

@IBDesignable
class BodyLabel: UILabel {
    
    @IBInspectable var textFocusAdapter:Int = 1 {
        didSet {
            textFocus = FontFocus(rawValue: textFocusAdapter) ?? .standard
        }
    }
    
    var textFocus:FontFocus = .standard {
        didSet {
            switch textFocus {
            case .prominent:
                self.textColor = Color.primary
            case .muted:
                self.textColor = Color.secondary
            default:
                self.textColor = Color.tertiary
            }
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
        textFocus = .standard
        self.font = UIFont(name: Assets.typeFace.regular, size: 16)
    }
    
    func setFontSize(at size:CGFloat) {
        self.font = UIFont(name: Assets.typeFace.regular, size: size)
    }
}
