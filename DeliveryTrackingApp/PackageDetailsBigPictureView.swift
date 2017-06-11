//
//  PackageDetailsBigPictureView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/6/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class PackageDetailsBigPictureView: UIView {

    @IBOutlet weak var titleGroup: TitleGroupWithProgressContent!
    @IBOutlet weak var mapView: FocusedMapView!
    @IBOutlet var view: UIView!
    var defaultHeight:CGFloat?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "PackageDetailsBigPictureView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
        self.view.bringSubview(toFront: titleGroup)
    }

    func changeMapViewAlpha(height: CGFloat) {
        let dftHeight = defaultHeight ?? 400
        if height >= 0 && height <= dftHeight {
            self.mapView.alpha = height/(dftHeight)
        }
    }
}
