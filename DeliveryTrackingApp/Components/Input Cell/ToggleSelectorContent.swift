//
//  ToggleSelectorContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class ToggleSelectorContent: UIView {

    @IBOutlet weak var toggleButton: LinkButton!
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: BodyLabel!
    
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "ToggleSelectorContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
    }
    
    func setToggleTitle(status:String) {
        toggleButton.setTitle(status, for: .normal)
    }
}
