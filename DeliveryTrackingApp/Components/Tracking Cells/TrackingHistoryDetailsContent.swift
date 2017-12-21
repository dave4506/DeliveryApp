//
//  TrackingHistoryDetailsContent.swift
//  DeliveryTrackingApp
//
//  Created by David Sun on 11/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class TrackingHistoryDetailsContent: UITableViewCell {

    @IBOutlet weak var bodyLabel: CaptionLabel!
    @IBOutlet weak var descriptionLabel: CaptionLabel!
    @IBOutlet weak var shadowView: ShadowView!
    
    weak var tableView:UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.backgroundColor = Color.background
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
