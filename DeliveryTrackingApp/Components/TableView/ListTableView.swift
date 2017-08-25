//
//  ListTableView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import AssistantKit

class ListTableView: UITableView {
    
    /*
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }*/
    
    var navBar:UINavigationBar?
    private var statusBarView:UIView?
    let contentOffsetDisposeBag = DisposeBag()
    var statusBarBlock:UIView?
    var defaultScrollPosition:CGFloat = 0.0;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    
    func commonInit() {
        self.estimatedRowHeight = 100.0
        self.rowHeight = UITableViewAutomaticDimension
        self.separatorStyle = .none
        
        self.autoresizesSubviews = true
        let headerView = UIView(frame:CGRect(origin:.zero,size:self.bounds.size))
        let footerView = UIView(frame:CGRect(origin:.zero,size:self.bounds.size))
        self.tableHeaderView = headerView
        self.tableFooterView = footerView
        self.setSectionHeader(height: 10)
        self.setSectionFooter(height: 10)
    }
    func setSectionHeader(height:CGFloat) {
        var newHeaderViewFrame = self.tableHeaderView?.frame
        newHeaderViewFrame?.size.height = height
        if let newHeaderViewFrame = newHeaderViewFrame {
            self.tableHeaderView?.frame = newHeaderViewFrame
        }
        self.reloadData()
    }
    
    func setSectionFooter(height:CGFloat) {
        var newFooterViewFrame = self.tableHeaderView?.frame
        newFooterViewFrame?.size.height = height
        if let newFooterViewFrame = newFooterViewFrame {
            self.tableFooterView?.frame = newFooterViewFrame
        }
        self.reloadData()
    }
    
    func generateNavBarOpacity(offset:CGFloat, navigationController:UINavigationController?, statusBar:Bool) {
        guard let navCon = navigationController else { return }
        self.navBar = navCon.navigationBar
        self.setUpNavBarOpacityChange(offset: offset,statusBar:statusBar)
        if statusBar {
            statusBarBlock = self.generateStatusBarView()
            navCon.view.addSubview(statusBarBlock!)
        }
    }
    
    func toggleStatusBar(_ status:Bool) {
        guard let navbar = self.navBar else { return }
        statusBarBlock?.isHidden = status;
        defaultScrollPosition = -1 * (navbar.frame.height + (!status ? 20:0))
    }
    
    func setUpNavBarOpacityChange(offset:CGFloat,statusBar:Bool) {
        guard offset > 0 else { return }
        guard let navbar = self.navBar else { return }
        navbar.layer.masksToBounds = false
        navbar.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        navbar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navbar.layer.shadowRadius = 5
        navbar.layer.shadowOpacity = 1
        defaultScrollPosition = -1 * (navbar.frame.height + (statusBar ? 20:0))
        self.rx.contentOffset.asObservable().subscribe(onNext:{ [weak self] scrollViewOffset in
            let refOffset = scrollViewOffset.y - (self?.defaultScrollPosition)!
            var color = UIColor.white
            if refOffset >= 0 && refOffset <= offset {
                let alpha = refOffset / offset
                color = UIColor.white.withAlphaComponent(alpha)
            } else if refOffset > offset {
                color = .white
            } else {
                color = .clear
            }
            navbar.backgroundColor = color
            self?.statusBarView?.backgroundColor = color
        }).addDisposableTo(contentOffsetDisposeBag)
    }
    
    func generateStatusBarView() -> UIView {
        statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarBlock?.isUserInteractionEnabled = false;
        return statusBarView!
    }
    
    deinit {
    }
}
