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

class SnackBar: UIView {
    
    @IBOutlet weak var snackLabel: BodyLabel!
    @IBOutlet var view: UIView!
    
    let disposeBag = DisposeBag()
    
    var opened = false
    
    var fabButton: FloatingActionButton?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func animateSnackBar(with message:String) {
        guard !opened else { return }
        guard let fabButton = fabButton else { return }
        opened = true
        self.transform = CGAffineTransform.identity
        fabButton.transform = CGAffineTransform.identity
        snackLabel.text = message
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -1 * self.frame.height)
            fabButton.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -1 * self.frame.height)
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: { [unowned self] in
                    self.closeSnackBar()
                })
        })
    }
    
    func closeSnackBar() {
        guard opened else { return }
        guard let fabButton = fabButton else { return }
        self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -1 * self.frame.height)
        fabButton.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -1 * self.frame.height)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            self.transform = CGAffineTransform.identity
            fabButton.transform = CGAffineTransform.identity
            }, completion: { [unowned self] _ in
                self.opened = false
        })
    }
    
    func commonInit() {
        UINib(nibName: "SnackBar", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        setConstraints()
        view.backgroundColor = Color.tertiary
        snackLabel.textColor = .white
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

