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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var unreadIndicator: UIView!
    @IBOutlet weak var locationTextLabel: CaptionLabel!
    @IBOutlet weak var carrierTextLabel: CaptionLabel!
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
    
    func setLoading(_ status:Bool) {
        if status {
            statusIconImageView.isHidden = true
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            statusIconImageView.isHidden = false
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
    func commonInit() {
        UINib(nibName: "PackageCellContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
        carrierTextLabel.textColor = Color.secondary
        carrierTextLabel.alpha = 0.3
        locationTextLabel.alpha = 0.5
        packageTitleLabel.textColor = Color.tertiary
        statusTextLabel.textColor = Color.secondary
        carrierTextLabel.isHidden = true
        packageTitleLabel.setFontSize(at: 20)
        statusTextLabel.setFontSize(at: 14)
        unreadIndicator.layer.cornerRadius = 4
        unreadIndicator.backgroundColor = Color.primary
    }
    
    func setPackageContent(with package:PrettyPackage) {
        setIcon(for: package.status!)
        statusTextLabel.text = package.status.description + " @\(package.statusLocation?.city ?? "") \(package.statusLocation?.state ?? "") \(package.statusLocation?.country ?? "")"
        if let title = package.title {
            if title.isEmpty {
                packageTitleLabel.text = package.trackingNumber
            } else {
                packageTitleLabel.text = title
            }
        } else {
            packageTitleLabel.text = package.trackingNumber
        }
        carrierTextLabel.text = package.carrier.capitalized
        locationTextLabel.text = package.carrier.capitalized
        unreadIndicator.isHidden = package.read
    }
    
    func setIcon(for status:PackageStatus) {
        switch status {
        case .uninitialized: statusIconImageView.image = nil;break
        case .awaiting: statusIconImageView.image = Assets.logo.dot;break
        case .error: fallthrough
        case .unknown: statusIconImageView.image = Assets.logo.cross.red; break
        case .delivered: statusIconImageView.image = Assets.logo.check.green; break
        case .outForDelivery: fallthrough
        case .traveling: statusIconImageView.image = Assets.logo.rightArrow.blue; break
        case .delay: statusIconImageView.image = Assets.logo.rightArrow.yellow; break
        }
    }
    
    deinit {
        loadingIndicator.stopAnimating()
    }
}

