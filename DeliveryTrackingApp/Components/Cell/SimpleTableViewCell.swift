//
//  SimpleTableViewCell.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/28/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: BodyLabel!
    @IBOutlet weak var descriptorLabel: BodyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: Assets.typeFace.regular, size: 16)
        titleLabel.textColor = Color.tertiary
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
