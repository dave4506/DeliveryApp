//
//  PackageCellContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class PackageCellContent: UIView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var carrierTextLabel: BodyLabel!
    @IBOutlet weak var packageTitleLabel: BodyLabel!
    @IBOutlet weak var statusTextLabel: BodyLabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    
    var package: PrettyPackage? {
        didSet  {
            guard let _ = package else { return }
            setPackageContent(with: package!)
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
    
    func commonInit() {
        UINib(nibName: "PackageCellContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        carrierTextLabel.textColor = Color.secondary
        packageTitleLabel.textColor = Color.tertiary
        statusTextLabel.textColor = Color.tertiary
        carrierTextLabel.setFontSize(at: 16)
        packageTitleLabel.setFontSize(at: 18)
        statusTextLabel.setFontSize(at: 18)
    }
    
    func setPackageContent(with package:PrettyPackage) {
        setIcon(for: package.status!)
        statusTextLabel.text = package.prettyStatus
        packageTitleLabel.text = package.title ?? package.id
        carrierTextLabel.text = package.carrier ?? "Unicorns"
    }
    
    func setIcon(for status:PackageStatus) {
        switch status {
        case .awaiting: statusIconImageView.image = Assets.logo.dot;break
        case .error: fallthrough
        case .unknown: statusIconImageView.image = Assets.logo.cross.red; break
        case .delivered: statusIconImageView.image = Assets.logo.check.green; break
        case .traveling: statusIconImageView.image = Assets.logo.rightArrow.blue; break
        }
    }
}

