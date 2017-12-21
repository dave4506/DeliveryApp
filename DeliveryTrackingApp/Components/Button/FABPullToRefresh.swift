//
//  FABPullToRefresh.swift
//  DeliveryTrackingApp
//
//  Created by David Sun on 11/24/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FABPullToRefresh: UIView {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var toastBackground: UIView!
    @IBOutlet weak var toastLabel: BodyLabel!
    @IBOutlet weak var fab: FloatingActionButton!
    @IBOutlet var view: UIView!
    
    let disposeBag = DisposeBag()
    var animatingRefreshStatus = false
    
    var openSnackBar = false
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func animateSnackBar(with message:String) {
        guard !openSnackBar else { return }
        bottomConstraint.constant = 0
        toastLabel.text = message
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
                self.view.layoutIfNeeded()
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: { [unowned self] in
                    self.closeSnackBar()
                })
        })
    }
    
    func closeSnackBar() {
        guard !openSnackBar else { return }
        bottomConstraint.constant = -56
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: { [unowned self] _ in
            self.openSnackBar = false
        })
    }
    
    func commonInit() {
        UINib(nibName: "FABPullToRefresh", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        setConstraints()
        toastBackground.backgroundColor = Color.tertiary
        toastLabel.textColor = .white
    }
    
    func setConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,bottomConstraint,topConstraint])
        view.layoutIfNeeded()
    }
}
