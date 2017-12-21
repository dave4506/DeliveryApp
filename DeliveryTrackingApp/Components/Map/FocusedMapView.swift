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
            removePolyLines()
            generatePolyLines()
        }
    }
    
    private var mapLines:[FocusedTrailMapLine] = []
    
    var cameraBounds:GMSCoordinateBounds?
    
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
        let mapInsets = UIEdgeInsets(top: 60, left: 10.0, bottom: 80.0, right: 10.0)
        self.mapView?.padding = mapInsets
    }
    
    func recenterCamera() {
        guard let cameraBounds = self.cameraBounds else { return }
        self.mapView?.animate(with:GMSCameraUpdate.fit(cameraBounds))
    }
    
    func removePolyLines() {
        mapLines.forEach {
            $0.removeFromMapView()
        }
    }
    
    func generatePolyLines() {
        var bounds = GMSCoordinateBounds()
        trails?.forEach { trail in
            let mapTrail:FocusedTrailMapLine = FocusedTrailMapLine(trail: trail)
            mapTrail.addTo(map: self.mapView!)
            mapLines.append(mapTrail)
            bounds = bounds.includingPath(mapTrail.path!)
            if let firstCord = trail.from {
                bounds = bounds.includingCoordinate(firstCord.convertToCLLocationCordinate2d())
            }
            if let destination = trail.destination {
                bounds = bounds.includingCoordinate(destination.convertToCLLocationCordinate2d())
            }
        }
        cameraBounds = bounds
        self.mapView?.animate(with:GMSCameraUpdate.fit(bounds))
    }
}
