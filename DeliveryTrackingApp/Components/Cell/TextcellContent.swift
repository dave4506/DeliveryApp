
//
//  TitleGroupContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class TextcellContent: UIView {
    
    @IBOutlet weak var bodyLabel: BodyLabel!
    @IBOutlet var view: UIView!
    
    var tableview: UITableView?

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "TextcellContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
    }

    override func layoutSubviews() {
        tableview?.reloadData()
        super.layoutSubviews()
    }
}
