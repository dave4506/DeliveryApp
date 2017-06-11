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
    var fromLocationStrokeCircle: GMSCircle?
    var currentLocationStrokeCircle: GMSCircle?
    var destinationFillCircle: GMSCircle?
    var circleStrokeWidth: CGFloat = 4
    var circleWidth: CGFloat = 18
    
    override init(trail:Trail) {
        super.init(trail: trail)
        pathPolyLine?.strokeColor = Color.primary
        if let firstCord = trail.path?.first {
            fromLocationStrokeCircle = GMSCircle(position: (firstCord.convertToCLLocationCordinate2d())!, radius: 1000)
            fromLocationStrokeCircle?.strokeColor = Color.primary
            fromLocationStrokeCircle?.strokeWidth = circleWidth - (2 * circleStrokeWidth)
        }
        if let lastCord = trail.path?.last {
            currentLocationStrokeCircle = GMSCircle(position: (lastCord.convertToCLLocationCordinate2d())!, radius: 1000)
            currentLocationStrokeCircle?.strokeColor = Color.primary
            currentLocationStrokeCircle?.strokeWidth = lastCord == trail.destination ? circleWidth : circleWidth - (2 * circleStrokeWidth)
        }
        if let destination = trail.destination {
            destinationFillCircle = GMSCircle(position: (destination.convertToCLLocationCordinate2d())!, radius: 1000)
            destinationFillCircle?.strokeColor = Color.accent
            destinationFillCircle?.strokeWidth = circleWidth - (2 * circleStrokeWidth)
        }
    }
    
    override func addTo(map mapView:GMSMapView) {
        super.addTo(map: mapView)
        fromLocationStrokeCircle?.map = mapView
        currentLocationStrokeCircle?.map = mapView
        destinationFillCircle?.map = mapView
    }
}

class UnfocusedTrailMapLine {
    var path: GMSMutablePath?
    var pathPolyLine: GMSPolyline?
    
    init(trail:Trail) {
        path = GMSMutablePath()
        //path?.add((trail.destination?.convertToCLLocationCordinate2d())!)
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
