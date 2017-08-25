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
    
    private func commonInit() {
        self.layer.cornerRadius = 10;
        camera = GMSCameraPosition.camera(withLatitude: 37.3011401, longitude: -122.0326018, zoom:4.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin:.zero,size:self.bounds.size) , camera: camera!)
        mapView?.layer.cornerRadius = 10
        loadMapStyle()
        self.addSubview(mapView!)
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
