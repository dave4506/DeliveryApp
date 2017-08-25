
//
//  TitleGroupContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class TitleSubContent: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var settingsButton: LinkButton!
    @IBOutlet weak var descriptionLabel: CaptionLabel!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "TitleSubContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
        self.descriptionLabel.isUserInteractionEnabled = true
    }

}
