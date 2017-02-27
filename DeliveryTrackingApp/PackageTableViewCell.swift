//
//  PackageTableViewCell.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class PackageTableViewCell: UITableViewCell {

    @IBOutlet weak var packageCellContent: PackageCellContent!
    var package:PrettyPackage? {
        didSet {
            guard let _ = package else { return }
            packageCellContent.package = package!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
