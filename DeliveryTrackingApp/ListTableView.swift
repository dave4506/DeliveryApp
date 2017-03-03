//
//  ListTableView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class ListTableView: UITableView {
    
    /*
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }*/
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    
    func commonInit() {
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.bounds.size))
        self.backgroundView = gradientView
        self.backgroundColor = .clear
        
        self.estimatedRowHeight = 120.0
        self.rowHeight = UITableViewAutomaticDimension
        
        self.separatorStyle = .none
        
        self.autoresizesSubviews = true
        let headerView = UIView(frame:CGRect(origin:.zero,size:self.bounds.size))
        self.tableHeaderView = headerView
        self.setSectionHeader(height: 150)
    }
    
    func setSectionHeader(height:CGFloat) {
        var newHeaderViewFrame = self.tableHeaderView?.frame
        newHeaderViewFrame?.size.height = height
        if let newHeaderViewFrame = newHeaderViewFrame {
            self.tableHeaderView?.frame = newHeaderViewFrame
        }
    }
}
