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

class PackageDetailsBigPictureView: GSKStretchyHeaderView {

    var mapControl: MapControls?
    var titleGroup: TitleGroupWithProgressContent?
    var mapView: FocusedMapView?
    var navBlock: UIView?
    
    var navBlockHeightConstraint: NSLayoutConstraint?

    var defaultHeight:CGFloat?
    var disposeBag = DisposeBag()
    var animating:Bool = false
    var openStatus:Bool = false {
        didSet {
            animateHeader(state:openStatus)
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
        print("common init")
        self.backgroundColor = .clear
        self.clipsToBounds = false;
        addMapView()
        addTitleGroup()
        addMapControl()
        addNavblock()
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
        guard let _ = titleGroup else { return }
        mapControl = MapControls(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mapControl!.recenterButton.rx.tap.subscribe(onNext:{ [unowned self] in
            self.mapView!.recenterCamera()
        }).addDisposableTo(disposeBag)
        self.addSubview(mapControl!)
        mapControl!.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: mapControl!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -164)
        let leadingConstraint = NSLayoutConstraint(item: mapControl!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: mapControl!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: mapControl!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        NSLayoutConstraint.activate([heightConstraint,leadingConstraint,trailingConstraint,bottomConstraint])
        mapControl!.layoutIfNeeded()
    }
    
    func addNavblock() {
        guard let _ = titleGroup else { return }
        navBlock = UIView()
        navBlock!.backgroundColor = Color.background
        self.addSubview(navBlock!)
        navBlock!.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: navBlock!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -154)
        let leadingConstraint = NSLayoutConstraint(item: navBlock!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: navBlock!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: navBlock!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64)
        navBlock?.alpha = 0;
        navBlockHeightConstraint = heightConstraint
        navBlock!.addConstraint(navBlockHeightConstraint!)
        NSLayoutConstraint.activate([heightConstraint,leadingConstraint,trailingConstraint,bottomConstraint])
        navBlock!.layoutIfNeeded()
    }
    
    func animateHeader(state:Bool) {
        if !animating {
            if state {
                self.titleGroup?.trailingConstraint?.constant = 0;
                self.titleGroup?.leadingConstraint?.constant = 0;
                self.titleGroup?.innerTrailingConstraint?.constant = 35;
                self.titleGroup?.innerLeadingConstraint?.constant = 35;
                navBlockHeightConstraint?.constant = 64;
            } else {
                self.titleGroup?.trailingConstraint?.constant = 20;
                self.titleGroup?.leadingConstraint?.constant = 20;
                self.titleGroup?.innerTrailingConstraint?.constant = 15;
                self.titleGroup?.innerLeadingConstraint?.constant = 15;
                navBlockHeightConstraint?.constant = 0;
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
                self.titleGroup?.layoutIfNeeded()
                if state {
                    self.navBlock?.alpha = 1;
                    self.titleGroup?.shadowView.layer.cornerRadius = 0;
                    self.titleGroup?.shadowView.layer.shadowOpacity = 0.15
                    self.titleGroup?.shadowView.layer.shadowOffset = CGSize(width:0,height:15)
                } else {
                    self.navBlock?.alpha = 0;
                    self.titleGroup?.shadowView.layer.cornerRadius = 5;
                    self.titleGroup?.shadowView.layer.shadowOpacity = 0.10
                    self.titleGroup?.shadowView.layer.shadowOffset = CGSize(width:0,height:10)
                }
            }, completion: { [unowned self] _ in
                    self.animating = false
            })
        }
    }
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        super.didChangeStretchFactor(stretchFactor)
        self.mapView?.alpha = stretchFactor
        self.mapControl?.alpha = stretchFactor
        if stretchFactor == 0 {
            mapView?.isHidden = true
            openStatus = true
        } else if openStatus == true {
            mapView?.isHidden = false
            openStatus = false
        }
        
    }
}
