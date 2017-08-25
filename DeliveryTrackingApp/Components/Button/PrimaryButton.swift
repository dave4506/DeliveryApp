//
//  PrimaryButton.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/11/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    
    let height: CGFloat = 56
    let padding: CGFloat = 16
    
    let isLoading: Bool = false
    
    
    override var isEnabled: Bool {
        didSet {
            self.layer.opacity = (isEnabled ? 1:0.5)
        }
    }
    
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
    
    func setToDefaultSize() {
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: 2*padding + self.bounds.width, height: height))
    }
    
    func commonInit() {
        layoutForeground();
        layoutBackground();
    }
    
    func layoutForeground() {
        self.tintColor = UIColor.white
        self.setTitle(self.titleLabel?.text, for: .normal)
        self.titleLabel?.font = UIFont(name: Assets.typeFace.regular, size: 14)
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        let attributedString = NSMutableAttributedString(string: (title?.uppercased() ?? ""))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: self.tintColor, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: attributedString.length))
        super.setAttributedTitle(attributedString, for: state)
    }
    
    func layoutBackground() {
        self.backgroundColor = Color.primary
        self.layer.cornerRadius = height/2
        self.layer.shadowColor = Color.primary.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 15
        self.layer.shadowOffset = CGSize(width:0,height:20)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
}
