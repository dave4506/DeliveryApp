//
//  ProgressBar.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
    
    var progress:CGFloat = 0.9 {
        didSet {
            setWidthAnimated(for: progress)
        }
    };
    
    var height:CGFloat = 24;
    var progressView: UIView?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        print(max(self.bounds.width,24))
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width:max(self.bounds.width,24),height:height))
        self.layer.cornerRadius = height/2;
        self.backgroundColor = Color.accent
        progressView = UIView(frame: CGRect(origin: CGPoint.zero, size: self.bounds.size))
        progressView?.layer.cornerRadius = 12;
        progressView?.backgroundColor = Color.primary
        progressView?.layer.shadowColor = Color.primary.cgColor
        progressView?.layer.shadowOpacity = 0.4
        progressView?.layer.shadowRadius = 15
        progressView?.layer.shadowOffset = CGSize(width:0,height:0)
        self.addSubview(progressView!)
        setWidth(for: 0)
    }
    
    func setWidth(for progress: CGFloat) {
        let cornerRadius = height/2
        let progressWidth = (self.bounds.width -  cornerRadius*2) * progress
        print(progressWidth)
        let size = CGSize(width: cornerRadius*2 + progressWidth,height:height)
        progressView?.frame = CGRect(origin: CGPoint.zero, size: size)
    }
    
    func setWidthAnimated(for progress: CGFloat) {
        let cornerRadius = height/2
        let progressWidth = (self.bounds.width -  cornerRadius*2) * progress
        let size = CGSize(width: cornerRadius*2 + progressWidth,height:height)
        UIView.animate(withDuration: 1,delay: 0.25,usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3,options: .curveEaseInOut, animations: { [weak self] in
            self?.progressView?.frame = CGRect(origin: .zero, size: size)
        }, completion: nil)
    }
}
