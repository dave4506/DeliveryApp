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
    var fromLocationMarker: GMSMarker?
    var currentLocationMarker: GMSMarker?
    var destinationMarker: GMSMarker?
    var renderedTrail:Trail?
    
    override init(trail:Trail) {
        super.init(trail: trail)
        pathPolyLine?.strokeColor = Color.primary
        renderedTrail = trail
        if let firstCord = trail.from {
            fromLocationMarker = GMSMarker()
            let markerImage = Assets.logo.marker.startMarker.withRenderingMode(.alwaysOriginal)
            let markerView = UIImageView(image:  self.imageWithImage(image: markerImage, scaledToSize: CGSize(width: 15, height: 15)))
            fromLocationMarker?.iconView = markerView
            fromLocationMarker?.position = firstCord.convertToCLLocationCordinate2d()
        }
        if let destination = trail.destination {
            destinationMarker = GMSMarker()
            let markerImage = Assets.logo.marker.endMarker.withRenderingMode(.alwaysOriginal)
            let markerView = UIImageView(image:  self.imageWithImage(image: markerImage, scaledToSize: CGSize(width: 20, height: 26)))
            destinationMarker?.iconView = markerView
            destinationMarker?.position = destination.convertToCLLocationCordinate2d()
        }
        if let lastCord = trail.path?.last, let destination = trail.destination {
            if lastCord != destination {
                currentLocationMarker = GMSMarker()
                let markerImage = Assets.logo.marker.startMarker.withRenderingMode(.alwaysOriginal)
                let markerView = UIImageView(image:  self.imageWithImage(image: markerImage, scaledToSize: CGSize(width: 15, height: 15)))
                currentLocationMarker?.iconView = markerView
                currentLocationMarker?.position = lastCord.convertToCLLocationCordinate2d()
            }
        }
    }
    
    override func addTo(bounds:GMSCoordinateBounds) -> GMSCoordinateBounds {
        let tempBounds = super.addTo(bounds: bounds)
        guard let trail = renderedTrail else { return bounds }
        if let firstCord = trail.from {
            tempBounds.includingCoordinate(firstCord.convertToCLLocationCordinate2d())
        }
        if let lastCord = trail.path?.last {
            tempBounds.includingCoordinate(lastCord.convertToCLLocationCordinate2d())
        }
        if let destination = trail.destination {
            tempBounds.includingCoordinate(destination.convertToCLLocationCordinate2d())
        }
        return tempBounds
    }
    
    override func addTo(map mapView:GMSMapView) {
        super.addTo(map: mapView)
        fromLocationMarker?.map = mapView
        currentLocationMarker?.map = mapView
        destinationMarker?.map = mapView
    }
    
    override func removeFromMapView() {
        super.removeFromMapView()
        fromLocationMarker?.map = nil
        currentLocationMarker?.map = nil
        destinationMarker?.map = nil
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

class UnfocusedTrailMapLine {
    var path: GMSMutablePath?
    var pathPolyLine: GMSPolyline?
    
    init(trail:Trail) {
        path = GMSMutablePath()
        trail.path?.forEach { pos in
            path?.add(pos.convertToCLLocationCordinate2d())
        }
        pathPolyLine = GMSPolyline(path:path!)
        pathPolyLine?.strokeColor = Color.primary.withAlphaComponent(0.2)
        pathPolyLine?.strokeWidth = 3.0
    }
    
    func addTo(map mapView:GMSMapView) {
        pathPolyLine?.map = mapView
    }
    
    func removeFromMapView() {
        pathPolyLine?.map = nil
    }
    
    func addTo(bounds: GMSCoordinateBounds) -> GMSCoordinateBounds {
        guard let path = path else { return bounds}
        bounds.includingPath(path)
        return bounds
    }
}
