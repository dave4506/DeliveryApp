//
//  TrailMapLine.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import GoogleMaps

class FocusedTrailMapLine:UnfocusedTrailMapLine {
    var currentLocationStrokeCircle: GMSCircle?
    var currentLocationFillCircle: GMSCircle?
    var circleStrokeWidth: CGFloat = 4
    var circleWidth: CGFloat = 18
    
    override init(trail:Trail) {
        super.init(trail: trail)
        pathPolyLine?.strokeColor = Color.primary
        pathPolyLine?.strokeWidth = 5.0
        let solidPrimary = GMSStrokeStyle.solidColor(Color.primary)
        let mutedPrimary = GMSStrokeStyle.solidColor(Color.primary.withAlphaComponent(0.5))
        pathPolyLine?.spans = [
            GMSStyleSpan(style: mutedPrimary),
            GMSStyleSpan(style: solidPrimary)
        ]
        currentLocationStrokeCircle = GMSCircle(position: (trail.currentPosition?.convertToCLLocationCordinate2d())!, radius: 1000)
        currentLocationStrokeCircle?.strokeColor = Color.primary
        currentLocationStrokeCircle?.strokeWidth = circleWidth
        currentLocationFillCircle = GMSCircle(position: (trail.currentPosition?.convertToCLLocationCordinate2d())!, radius: 1000)
        currentLocationFillCircle?.strokeColor = Color.accent
        currentLocationFillCircle?.strokeWidth = circleWidth - (2 * circleStrokeWidth)
    }
    
    override func addTo(map mapView:GMSMapView) {
        super.addTo(map: mapView)
        currentLocationStrokeCircle?.map = mapView
        currentLocationFillCircle?.map = mapView
    }
}

class UnfocusedTrailMapLine {
    var path: GMSMutablePath?
    var pathPolyLine: GMSPolyline?
    
    init(trail:Trail) {
        path = GMSMutablePath()
        path?.add((trail.destination?.convertToCLLocationCordinate2d())!)
        trail.path?.forEach { pos in
            path?.add(pos.convertToCLLocationCordinate2d()!)
        }
        pathPolyLine = GMSPolyline(path:path!)
        pathPolyLine?.strokeColor = Color.primary.withAlphaComponent(0.2)
        pathPolyLine?.strokeWidth = 3.0
    }
    
    func addTo(map mapView:GMSMapView) {
        pathPolyLine?.map = mapView
    }
}
