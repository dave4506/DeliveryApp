//
//  FloatingActionButton.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/11/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButton {

    let size: CGFloat = 56
    let padding: CGFloat = 16
    var circleView: UIView?
    var buttonIcon: UIImage = Assets.logo.add.white {
        didSet {
            layoutButtonImage()
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
        self.setTitle(nil, for: .normal)
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: size, height: size))
        self.layoutCircleView()
        self.layoutButtonImage()
    }
    
    func layoutCircleView() {
        circleView = UIView(frame: CGRect(origin:CGPoint(x:0,y:0), size: self.bounds.size))
        circleView?.clipsToBounds = false
        circleView?.layer.cornerRadius = self.bounds.width/2;
        circleView?.backgroundColor = Color.primary
        circleView?.layer.shadowColor = Color.primary.cgColor
        circleView?.layer.shadowOpacity = 0.4
        circleView?.layer.shadowRadius = 15
        circleView?.layer.shadowOffset = CGSize(width:0,height:20)
        self.addSubview(circleView!)
    }
    
    func layoutButtonImage() {
        let iconView = UIImageView(image: buttonIcon)
        iconView.frame = CGRect(origin: CGPoint(x:padding,y:padding), size: CGSize(width: size - 2*padding, height: size - 2*padding ))
        self.addSubview(iconView)
    }
    
    func animateShadowDown() {
        let shadowPositionAnim = CABasicAnimation()
        shadowPositionAnim.keyPath = "shadowOffset"
        shadowPositionAnim.fromValue = CGSize(width:0,height:40)
        shadowPositionAnim.toValue = CGSize(width:0,height:20)
        shadowPositionAnim.duration = 0.3
        let shadowRadiusAnim = CABasicAnimation()
        shadowRadiusAnim.keyPath = "shadowRadius"
        shadowRadiusAnim.fromValue = 10
        shadowRadiusAnim.toValue = 15
        shadowRadiusAnim.duration = 0.1
        circleView?.layer.add(shadowPositionAnim, forKey: "shadowOffset")
        circleView?.layer.add(shadowRadiusAnim, forKey: "shadowRadius")
        circleView?.layer.shadowRadius = 15
        circleView?.layer.shadowOffset = CGSize(width:0,height:20)
    }
    
    func animateShadowUp() {
        let shadowPositionAnim = CABasicAnimation()
        shadowPositionAnim.keyPath = "shadowOffset"
        shadowPositionAnim.fromValue = CGSize(width:0,height:20)
        shadowPositionAnim.toValue = CGSize(width:0,height:40)
        shadowPositionAnim.duration = 0.3
        let shadowRadiusAnim = CABasicAnimation()
        shadowRadiusAnim.keyPath = "shadowRadius"
        shadowRadiusAnim.fromValue = 15
        shadowRadiusAnim.toValue = 10
        shadowRadiusAnim.duration = 0.1
        circleView?.layer.add(shadowPositionAnim, forKey: "shadowOffset")
        circleView?.layer.add(shadowRadiusAnim, forKey: "shadowRadius")
        circleView?.layer.shadowRadius = 10
        circleView?.layer.shadowOffset = CGSize(width:0,height:40)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateShadowUp()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateShadowDown()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateShadowDown()
    }
}
