//
//  UnfocusedMapView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import GoogleMaps

class UnfocusedMapView: UIView {
    
    var mapView: GMSMapView?
    var camera: GMSCameraPosition?
    var isLoading = false {
        didSet {
            if isLoading != oldValue {
                setLoading()
            }
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
    
    override func layoutSubviews() {
        mapView?.frame = CGRect(origin:.zero,size:self.bounds.size)
    }
    
    func setLoading() {
        if isLoading {
            self.alpha = 0.4
            mapView?.isHidden = true
            animateLoading(opacity: 0)
        } else {
            self.alpha = 1
            mapView?.isHidden = false
        }
    }
    
    func animateLoading(opacity:CGFloat) {
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            self.alpha = opacity
            }, completion: { [unowned self] _ in
                if self.isLoading || opacity == 0.2 {
                    self.animateLoading(opacity: opacity == 0.2 ? 0:0.2)
                }
                if !self.isLoading {
                    self.alpha = 1
                }
        })
    }
    private func commonInit() {
        self.layer.cornerRadius = 10;
        camera = GMSCameraPosition.camera(withLatitude: 37.3011401, longitude: -122.0326018, zoom:4.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin:.zero,size:self.bounds.size) , camera: camera!)
        mapView?.layer.cornerRadius = 10
        loadMapStyle()
        self.addSubview(mapView!)
        self.backgroundColor = Color.accent
        print(frame)
    }
    
    func loadMapStyle()  {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
                mapView?.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }

    }
}
