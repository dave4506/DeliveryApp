//
//  SideActionButton.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/11/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class SideActionButton: UIButton {
    
    let height: CGFloat = 56
    let padding: CGFloat = 16
    
    var ishiddenSideways: Bool = false {
        didSet {
            if oldValue != ishiddenSideways {
                animate(enabled: ishiddenSideways)
            }
        }
    }
    
    func animate(enabled: Bool) {
        //self.isEnabled = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            if enabled {
                self.frame = CGRect(origin: CGPoint(x:self.frame.origin.x - self.frame.width,y:self.frame.origin.y), size: self.frame.size)
            } else {
                self.frame = CGRect(origin: CGPoint(x:self.frame.origin.x + self.frame.width,y:self.frame.origin.y), size: self.frame.size)
            }
        }, completion: { _ in
            //self.isEnabled = true
        })
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
    
    func commonInit() {
        layoutForeground();
        layoutBackground();
        ishiddenSideways = false;
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
        let maskPath = UIBezierPath(roundedRect: CGRect(origin:CGPoint.zero,size:CGSize(width:self.bounds.width,height:height)),
                                    byRoundingCorners: [.topLeft,.bottomLeft],
                                    cornerRadii: CGSize(width: 8, height: 8))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        let backgroundView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:self.bounds.width,height:height)))
        backgroundView.layer.mask = shape
        backgroundView.backgroundColor = Color.primary
        backgroundView.isUserInteractionEnabled = false
        self.titleLabel?.layer.zPosition = 1
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.addSubview(backgroundView)
        self.layer.shadowColor = Color.primary.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 15
        self.layer.shadowOffset = CGSize(width:0,height:10)
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
