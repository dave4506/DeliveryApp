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
        self.estimatedRowHeight = 200.0
        self.rowHeight = UITableViewAutomaticDimension
        
        self.separatorStyle = .none
        
        self.autoresizesSubviews = true
        let headerView = UIView(frame:CGRect(origin:.zero,size:self.bounds.size))
        let footerView = UIView(frame:CGRect(origin:.zero,size:self.bounds.size))
        self.tableHeaderView = headerView
        self.tableFooterView = footerView
        self.setSectionHeader(height: 80)
    }
    
    func setSectionHeader(height:CGFloat) {
        var newHeaderViewFrame = self.tableHeaderView?.frame
        newHeaderViewFrame?.size.height = height
        if let newHeaderViewFrame = newHeaderViewFrame {
            self.tableHeaderView?.frame = newHeaderViewFrame
        }
    }
    
    func setSectionFooter(height:CGFloat) {
        var newFooterViewFrame = self.tableHeaderView?.frame
        newFooterViewFrame?.size.height = height
        if let newFooterViewFrame = newFooterViewFrame {
            self.tableFooterView?.frame = newFooterViewFrame
        }
    }
}
