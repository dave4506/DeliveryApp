//
//  StateCardTableViewCell.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/5/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class StateCardTableViewCell: UITableViewCell {

    @IBOutlet weak var stateCard: StateCard!

    var status:PrettyStatus? {
        didSet {
            guard let _ = status else { return }
            stateCard.status = status!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
