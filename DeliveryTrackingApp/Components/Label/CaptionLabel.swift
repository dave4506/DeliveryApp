//
//  CaptionLabel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/10/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

@IBDesignable
class CaptionLabel: UILabel {
    
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
        self.font = UIFont(name: Assets.typeFace.regular, size: 14)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenu)))
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func showMenu(sender: AnyObject?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
}
