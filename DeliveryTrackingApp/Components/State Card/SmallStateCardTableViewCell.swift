//
//  StateCardTableViewCell.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/5/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class SmallStateCardTableViewCell: UITableViewCell {

    @IBOutlet weak var stateCard: SmallStateCard!

    weak var tableView:UITableView?
    
    var status:PrettyStatus? {
        didSet {
            guard let _ = status else { return }
            stateCard.status = status!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.stateCard.tableView = tableView
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getCellHeight() -> CGFloat {
        return 190.0
    }
}
