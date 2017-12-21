//
//  EmptyPackageCell.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class LoadingPackageCell: UITableViewCell {

    @IBOutlet weak var grayDescriptionView: UIView!
    @IBOutlet weak var grayIconView: UIView!
    @IBOutlet weak var grayCarrierView: UIView!
    @IBOutlet weak var grayTitleView: UIView!
    
    private var animating:Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        grayIconView.layer.cornerRadius = 10
        self.selectionStyle = .none
        self.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startAnimation(delay:TimeInterval?) {
        if !animating {
            animating = true
            animateBreathe(delay: delay)
        }
    }
    
    func animateBreathe(delay:TimeInterval?) {
        self.alpha = 1;
        UIView.animate(withDuration: 1, delay: delay ?? 0.0, options: [.curveLinear],
            animations: { [weak self] in
                self?.alpha = 0;
        },
            completion: { [weak self] _ in
                guard let animating = self?.animating else { return }
                if animating {
                    self?.animateBreatheIn(delay:0)
                }
        })
    }
    
    func animateBreatheIn(delay:TimeInterval?) {
        self.alpha = 0;
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear],
            animations: { [weak self] in
                self?.alpha = 1;
        },
            completion: { [weak self] _ in
                guard let animating = self?.animating else { return }
                if animating {
                    self?.animateBreathe(delay:0)
                }
        })
    }
    
    func stopAnimaion() {
        animating = false
    }
    
    deinit {
        stopAnimaion()
    }
}
