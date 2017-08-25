//
//  OnboardCard.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class OnboardAddPackage: UIView {

    @IBOutlet weak var doneButton: LinkButton!
    @IBOutlet weak var addButton: FloatingActionButton!
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
        UINib(nibName: "OnboardAddPackage", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
    }
}
