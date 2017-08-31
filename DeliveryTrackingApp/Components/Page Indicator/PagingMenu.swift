
//
//  TitleGroupContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PagingMenu: UIView {
    
    enum Page {
        case home,archive,settings
    }

    @IBOutlet var view: UIView!
    @IBOutlet weak var homeButton: LinkButton!
    @IBOutlet weak var archiveButton: LinkButton!
    @IBOutlet weak var settingsButton: LinkButton!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func setStatusBar(_ status:Bool) {
        statusBarHeight.constant = status ? 20:0
    }
    
    func setActive(page:Page) {
        self.animateButton(self.archiveButton, active: page == .archive)
        self.animateButton(self.homeButton, active:  page == .home)
        self.animateButton(self.settingsButton, active: page == .settings)
    }
    
    func commonInit() {
        UINib(nibName: "PagingMenu", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        archiveButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.animateButton(self.archiveButton, active: true)
            self.animateButton(self.homeButton, active: false)
            self.animateButton(self.settingsButton, active: false)
        }).disposed(by:disposeBag)
        homeButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.animateButton(self.archiveButton, active: false)
            self.animateButton(self.homeButton, active: true)
            self.animateButton(self.settingsButton, active: false)
        }).disposed(by:disposeBag)
        settingsButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.animateButton(self.archiveButton, active: false)
            self.animateButton(self.homeButton, active: false)
            self.animateButton(self.settingsButton, active: true)
        }).disposed(by:disposeBag)
        self.layer.shadowColor = Color.tertiary.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 30
        self.layer.shadowOffset = CGSize(width:0,height:10)
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
