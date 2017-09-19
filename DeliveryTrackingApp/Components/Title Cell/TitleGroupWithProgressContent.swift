
//
//  TitleGroupContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class TitleGroupWithProgressContent: UIView {
    
    @IBOutlet weak var innerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var captionLabelOne: CaptionLabel!
    @IBOutlet weak var captionLabelTwo: CaptionLabel!
    
    var prettyPackage: PrettyPackage? {
        didSet {
            if let title = prettyPackage?.title {
                if title.isEmpty {
                    titleLabel.text = prettyPackage?.trackingNumber
                } else {
                    titleLabel.text = title
                }
            } else {
                titleLabel.text = prettyPackage?.trackingNumber
            }
            self.captionLabelOne.text = prettyPackage?.carrier.uppercased()
            self.captionLabelTwo.text = prettyPackage?.status.description.uppercased()
            self.progressBar.progress = CGFloat(prettyPackage?.durationPercentage ?? 0)
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func redrawProgress() {
        guard let prettyPackage = self.prettyPackage else { return }
        self.progressBar.progress = CGFloat(prettyPackage.durationPercentage ?? 0)
    }
    
    func commonInit() {
        UINib(nibName: "TitleGroupWithProgressContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
    }

}
