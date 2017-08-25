//
//  OptionView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class OptionView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var selectorLabel: BodyLabel!

    var selectedIndex:Int = 0;
    
    var defaultIndex:Int = 0;

    var status: Bool = false {
        didSet {
            setSelectedStyle(status: status)
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
        UINib(nibName: "OptionView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
        circleView.layer.cornerRadius = 13
        circleView.backgroundColor = Color.primary
        setSelectedStyle(status: status)
    }
    
    func setSelectedStyle(status:Bool) {
        if status {
            circleView.alpha = 1
            selectorLabel.textFocus = .standard
        } else {
            circleView.alpha = 0.5
            selectorLabel.textFocus = .muted
        }
    }
}
