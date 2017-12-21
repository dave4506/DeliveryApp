//
//  CapCellDataSource.swift
//  DeliveryTrackingApp
//
//  Created by David Sun on 11/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit

class CapCellDataSource {
    
    struct capIdentifiers {
        static let top = "top"
        static let bottom = "bottom"
    }
    
    init() {
    }
    
    func registerCells(tableView: UITableView) {
        tableView.register(UINib(nibName: "TopCapCell", bundle: nil), forCellReuseIdentifier: capIdentifiers.top)
        tableView.register(UINib(nibName: "BottomCapCell", bundle: nil), forCellReuseIdentifier: capIdentifiers.bottom)
    }
}
