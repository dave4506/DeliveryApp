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

class PageViewIndicator: UIView {
    
    @IBOutlet weak var archiveButton: LinkButton!
    @IBOutlet var view: UIView!
    @IBOutlet weak var homeButton: LinkButton!
    
    let focusIndex = 0;
    
    let disposeBag = DisposeBag()
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "PageViewIndicator", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        archiveButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.animateButton((self?.archiveButton)!, active: true)
            self?.animateButton((self?.homeButton)!, active: false)
        }).disposed(by:disposeBag)
        homeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.animateButton((self?.archiveButton)!, active: false)
            self?.animateButton((self?.homeButton)!, active: true)
        }).disposed(by:disposeBag)
    }

    func animateButton(_ button:LinkButton,active:Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            if active {
                button.setTitleColor(Color.primary, for: .normal)
                //button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1);
            } else {
                button.setTitleColor(Color.secondary, for: .normal)
                //button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            }
        }, completion: { _ in
        })
    }
}
