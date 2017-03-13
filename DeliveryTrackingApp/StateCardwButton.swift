//
//  StateCardwButton.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class StateCardwButton: UIView {

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
        UINib(nibName: "StateCard", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
}
