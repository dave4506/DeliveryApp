//
//  SimpleTableViewCell.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/28/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

struct SimpleTableData {
    var title:String?
    var description:String?
}

class SimpleTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptorLabel: BodyLabel!
    @IBOutlet weak var titleLabel: BodyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
