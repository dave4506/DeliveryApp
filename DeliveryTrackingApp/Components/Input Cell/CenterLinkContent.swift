//
//  CenterLinkContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class CenterLinkContent: UIView {

    @IBOutlet weak var linkButton: LinkButton!
    @IBOutlet var view: UIView!
    
    var linkTitle:String? {
        didSet {
            guard let _ = linkTitle else { return }
            linkButton.setTitle(linkTitle!,for: .normal)
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
        UINib(nibName: "CenterLinkContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
    }
}
