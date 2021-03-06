//
//  OnboardCard.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class OnboardCard: UIView {

    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var customOnboardContentView: UIView!
    @IBOutlet weak var onboardDescription: BodyLabel!
    @IBOutlet weak var onboardTitle: TitleLabel!
    @IBOutlet weak var onboardImageView: UIImageView!
    @IBOutlet var view: UIView!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "OnboardCard", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        onboardTitle.setFontSize(at:24)
        onboardDescription.setFontSize(at:16)
        self.backgroundColor = .clear
    }
}
