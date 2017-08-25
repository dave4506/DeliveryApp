//
//  StatsView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit
import ESPullToRefresh

enum RefreshState {
    case unintiated,loading
}

class RefreshControls: UIView, ESRefreshAnimatorProtocol {
    
    @IBOutlet var refreshView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshImage: UIImageView!
    
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var view: UIView { return self }
    public var duration: TimeInterval = 0.3
    public var trigger: CGFloat = 56.0
    public var executeIncremental: CGFloat = 56.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    var refreshState:RefreshState = .unintiated
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "RefreshControls", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(refreshView)
        refreshView.frame = self.bounds
        refreshImage.image = Assets.logo.leftArrow
        refreshImage.alpha = 0.2
        refreshImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.5)
        loadingIndicator.isHidden = true
    }
}

extension RefreshControls {
    func breath(_ breathIn:Bool) {
        if breathIn {
            self.refreshImage.alpha = 1
        } else {
            self.refreshImage.alpha = 0
        }
    }
    func animateBreath(_ breathIn:Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.breath(breathIn)
        }, completion: { [weak self] _ in
            if self?.refreshState == .loading {
                self?.animateBreath(breathIn)
            }
        })
    }
}

extension RefreshControls: ESRefreshProtocol {
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        self.refreshImage.isHidden = true;
        self.loadingIndicator.isHidden = false;
        self.loadingIndicator.startAnimating();
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        self.refreshImage.isHidden = false;
        self.loadingIndicator.isHidden = true;
        self.loadingIndicator.stopAnimating();
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {

    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        switch state {
        case .pullToRefresh:
            refreshImage.alpha = 0.2
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                [unowned self] in
                self.refreshImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.5)
            }) { (animated) in }
            break
        case .releaseToRefresh:
            refreshImage.alpha = 0.2
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
