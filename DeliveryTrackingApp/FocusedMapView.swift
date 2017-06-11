//
//  FocusedMapView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import GoogleMaps

class FocusedMapView: UnfocusedMapView {

    var activeTrailIndex:Int?
    
    var trails:[Trail]? {
        didSet {
            generatePolyLines()
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        generatePolyLines()
        self.mapView?.settings.scrollGestures = true
        self.mapView?.settings.zoomGestures = true
        self.mapView?.settings.compassButton = true
        let mapInsets = UIEdgeInsets(top: 10, left: 10.0, bottom: 10.0, right: 10.0)
        self.mapView?.padding = mapInsets

        //self.layer.shadowColor = Color.tertiary.cgColor
        //self.layer.shadowOpacity = 0.2
        //self.layer.shadowRadius = 30
        //self.layer.shadowOffset = CGSize(width:0,height:0)
    }
    
    func generatePolyLines() {
        var bounds = GMSCoordinateBounds()
        trails?.forEach { trail in
            let mapTrail:UnfocusedTrailMapLine = FocusedTrailMapLine(trail: trail)
            mapTrail.addTo(map: self.mapView!)
            bounds = bounds.includingPath(mapTrail.path!)
        }
        self.mapView?.animate(with:GMSCameraUpdate.fit(bounds))
    }
}
