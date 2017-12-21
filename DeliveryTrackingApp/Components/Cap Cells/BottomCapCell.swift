//
//  BottomCapCell.swift
//  DeliveryTrackingApp
//
//  Created by David Sun on 11/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class BottomCapCell: UITableViewCell, CapCell {

    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var spacingConstraint: NSLayoutConstraint!

    var position:CapCellContentPosition = .bottomCap;

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        self.selectionStyle = .none
        spacingConstraint.constant = 20
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
