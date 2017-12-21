//
//  TrackingHistoryCell1.swift
//  DeliveryTrackingApp
//
//  Created by David Sun on 10/7/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit

class TrackingHistoryCell: UITableViewCell {
    
    @IBOutlet weak var detailContent: DetailDropDownContent!
    
    override func awakeFromNib() {
        self.selectionStyle = .none;
        self.clipsToBounds = false;
    }
}

