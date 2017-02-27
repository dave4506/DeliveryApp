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

    struct textStatus {
    static var on = "ON"
    static var off = "OFF"
    }
    
    var status:Bool = false {
        didSet {
            setToggleTitle(status: status)
        }
    }
    
    @IBAction func tappedAction(_ sender: Any) {
        status = !status
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
        UINib(nibName: "ToggleSelectorContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
        setToggleTitle(status: status)
    }
    
    func setToggleTitle(status:Bool) {
        toggleButton.setTitle(status ? textStatus.on:textStatus.off,for: .normal)
    }
}
