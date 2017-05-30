//
//  TextfieldGroupContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class TextfieldGroupContent: UIView {

    @IBOutlet weak var input: Textfield!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet var view: UIView!
    
    var icon: UIImage = Assets.logo.package.closed {
        didSet {
            iconImageView.image = icon
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
        UINib(nibName: "TextfieldGroupContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
    }
    
}
