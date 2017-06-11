//
//  ListTableView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift

class ListTableView: UITableView {
    
    /*
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }*/
    
    var navBar:UINavigationBar?
    private var statusBarView:UIView?
    let disposeBag = DisposeBag()
    
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
    }
    
    func setSectionFooter(height:CGFloat) {
        var newFooterViewFrame = self.tableHeaderView?.frame
        newFooterViewFrame?.size.height = height
        if let newFooterViewFrame = newFooterViewFrame {
            self.tableFooterView?.frame = newFooterViewFrame
        }
    }
    
    func generateNavBarOpacity(offset:CGFloat, navigationController:UINavigationController?) {
        guard let navCon = navigationController else { return }
        self.navBar = navCon.navigationBar
        self.setUpNavBarOpacityChange(offset: offset)
        navCon.view.addSubview(self.generateStatusBarView())
    }
    
    func setUpNavBarOpacityChange(offset:CGFloat) {
        guard offset > 0 else { return }
        guard let navbar = self.navBar else { return }
        navbar.layer.masksToBounds = false
        navbar.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        navbar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navbar.layer.shadowRadius = 5
        navbar.layer.shadowOpacity = 1
        let defaultScrollPosition = -1 * (navbar.frame.height + 20)
        self.rx.contentOffset.asObservable().subscribe(onNext:{ [weak self] scrollViewOffset in
            let refOffset = scrollViewOffset.y - defaultScrollPosition
            //print("scrollViewOffest:\(scrollViewOffset.y) default:\(defaultScrollPosition) ref:\(refOffset)")
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
        }).addDisposableTo(disposeBag)
    }
    
    func generateStatusBarView() -> UIView {
        statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        //statusBarView?.backgroundColor = .red
        return statusBarView!
    }
    
    deinit {
    }
}
