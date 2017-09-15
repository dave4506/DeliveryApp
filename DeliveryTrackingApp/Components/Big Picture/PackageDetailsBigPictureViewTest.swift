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
import GSKStretchyHeaderView

class PackageDetailsBigPictureViewTest: GSKStretchyHeaderView {

    var mapControl: MapControls?
    var titleGroup: TitleGroupWithProgressContent?
    var mapView: FocusedMapView?
    
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
        print("common init")
        self.backgroundColor = .clear
        self.clipsToBounds = false;
        addMapView()
        addTitleGroup()
        addMapControl()
        //self.bringSubview(toFront: titleGroup)
        //self.bringSubview(toFront: mapControl)
        //self.mapControl.recenterButton.rx.tap.subscribe(onNext:{ [weak self] in
        //    self?.mapView.recenterCamera()
        //}).addDisposableTo(disposeBag)
    }

    func addMapView() {
        mapView = FocusedMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.addSubview(mapView!)
        mapView!.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: mapView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: mapView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: mapView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: mapView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -82)
        NSLayoutConstraint.activate([bottomConstraint,topConstraint,leadingConstraint,trailingConstraint])
        mapView!.layoutIfNeeded()
    }
    
    func addTitleGroup() {
        titleGroup = TitleGroupWithProgressContent(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.addSubview(titleGroup!)
        titleGroup!.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: titleGroup!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: titleGroup!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: titleGroup!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: titleGroup!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 164)
        NSLayoutConstraint.activate([heightConstraint,leadingConstraint,trailingConstraint,bottomConstraint])
        titleGroup!.layoutIfNeeded()
    }
    
    func addMapControl() {
        guard let titleGroup = titleGroup else { return }
        mapControl = MapControls(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.addSubview(mapControl!)
        mapControl!.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: mapControl!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -164)
        let leadingConstraint = NSLayoutConstraint(item: mapControl!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: mapControl!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: mapControl!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        NSLayoutConstraint.activate([heightConstraint,leadingConstraint,trailingConstraint,bottomConstraint])
        mapControl!.layoutIfNeeded()
    }
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        super.didChangeStretchFactor(stretchFactor)
        //self.mapView?.alpha = stretchFactor
        self.mapControl?.alpha = stretchFactor
    }
}
