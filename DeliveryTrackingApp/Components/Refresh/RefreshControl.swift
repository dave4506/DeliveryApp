//
//  StatsView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RefreshControl: UIRefreshControl {
    
    @IBOutlet var refreshView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshImage: UIImageView!
    
    let disposeBag = DisposeBag()

    var isRefreshControlAnimating = false
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "RefreshControl", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(refreshView)
        setUpRefreshControl()
    }
    
    func setUpRefreshControl() {
        refreshView.frame = self.bounds
        refreshImage.image = Assets.logo.leftArrow
        refreshImage.alpha = 0.2
        refreshImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.5)
        loadingIndicator.isHidden = true
    }
    
    func refreshAnimationBegin() {
        self.refreshImage.isHidden = true;
        self.loadingIndicator.isHidden = false;
        self.loadingIndicator.startAnimating();
    }
    
   func refreshAnimationEnd() {
        self.refreshImage.isHidden = false;
        self.loadingIndicator.isHidden = true;
        self.loadingIndicator.stopAnimating();
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pullDistance = max(0.0, -self.frame.origin.y);
        let pullRatio = min(max(pullDistance, 0.0), 140.0) / 140.0;
        
    }
}

/*
extension RefreshControls: ESRefreshProtocol {

    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        switch state {
        case .pullToRefresh:
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                [unowned self] in
                self.refreshImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.5)
            }) { (animated) in }
            break
        case .releaseToRefresh:
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                [unowned self] in
                self.refreshImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -1.5)
            }) { (animated) in }
            break
        default:
            break
        }
    }
}
*/
