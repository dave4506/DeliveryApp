//
//  PackageDetailsBigPictureView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/6/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PackageDetailsBigPictureView: UIView {

    @IBOutlet weak var mapControl: MapControls!
    @IBOutlet weak var refreshControls: RefreshControls!
    @IBOutlet weak var titleGroup: TitleGroupWithProgressContent!
    @IBOutlet weak var mapView: FocusedMapView!
    @IBOutlet var view: UIView!
    var defaultHeight:CGFloat?
    var disposeBag = DisposeBag()
    
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
        self.view.bringSubview(toFront: refreshControls)
        self.view.bringSubview(toFront: mapControl)
        //TEMPORARY DISABLE REFRESH CONTROLS
        self.refreshControls.isUserInteractionEnabled = false
        self.refreshControls.isHidden = true
        self.mapControl.recenterButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.mapView.recenterCamera()
        }).addDisposableTo(disposeBag)
    }

    func changeAlpha(height: CGFloat) {
        let dftHeight = defaultHeight ?? 400
        if height >= 0 && height <= dftHeight {
            self.mapView.alpha = height/(dftHeight)
            self.mapControl.alpha = height/(dftHeight)
        }
    }
    
}
