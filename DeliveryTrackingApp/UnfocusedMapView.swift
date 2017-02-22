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
    
    private func commonInit() {
        self.layer.cornerRadius = 10;
        camera = GMSCameraPosition.camera(withLatitude: 37.3011401, longitude: -122.0326018, zoom:4.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin:.zero,size:self.bounds.size) , camera: camera!)
        mapView?.layer.cornerRadius = 10
        loadMapStyle()
        self.addSubview(mapView!)
        self.layer.shadowColor = Color.tertiary.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 30
        self.layer.shadowOffset = CGSize(width:0,height:0)
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
