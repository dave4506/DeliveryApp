
//
//  TitleGroupContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class TitleLabelContent: UIView {
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var updatedLabel: CaptionLabel!
    
    var animatingButton = false
    
    var refreshState:RefreshState = .stop {
        didSet{
            changeButton(to: refreshState)
        }
    }
    
    enum RefreshState {
        case loading, stop, pulled(CGFloat)
    }
    
    enum Fade {
        case full, faded
    }
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "TitleLabelContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
        self.refreshButton.alpha = 0.4
    }

    func changeButton(to refreshState: RefreshState) {
        switch refreshState {
        case .loading:
            animatingButton = true
            fadeButton(to: .full) { [unowned self] _ in
                self.refreshButton.alpha = 1
                self.animateButton(rotate:1)
            }
        case .stop:
            animatingButton = false
            fadeButton(to: .faded) { [unowned self] _ in
                self.refreshButton.alpha = 0.4
            }
        case let .pulled(percentage): self.refreshButton.alpha = percentage
        }
    }
    
    func fadeButton(to fade:Fade, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            if fade == .full {
                self.refreshButton.alpha = 1
            } else {
                self.refreshButton.alpha = 0.4
            }
        }, completion: completion)
    }
    
    func animateButton(rotate:CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * rotate)
        }, completion: { [unowned self] _ in
            if self.animatingButton {
                self.animateButton(rotate: rotate == 1 ? 2:1)
            }
        })
    }
}
