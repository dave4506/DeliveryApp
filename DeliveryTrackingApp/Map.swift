//
//  Map.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

struct Position {
    let lat:Double?
    let long:Double?
    func convertToCLLocationCordinate2d() -> CLLocationCoordinate2D? {
        guard let long = long, let lat = lat else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    static func convert(location:Location) -> Observable<Position?> {
        return Observable.create { observer in
            CLGeocoder().geocodeAddressString(location.description, completionHandler: { (placemarks, error) in
                if let error = error {
                    observer.onError(error)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let coords = placemarks[0].location?.coordinate
                        observer.onNext(Position(lat:coords?.latitude,long:coords?.longitude))
                    }
                }
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
}

extension Position:CustomStringConvertible {
    var description:String {
        return "lat:\(self.lat) long:\(self.long)"
    }
}

extension Position:Equatable {
    static func == (lhs: Position, rhs: Position) -> Bool {
        return
            lhs.lat == rhs.lat &&
                lhs.long == rhs.long
    }
}

struct Location {
    let city:String?
    let country: String?
    let state: String?
    let zip: String?
    static func convert(dict:[String:AnyObject]) -> Location {
        let city = dict["city"] as! String
        let country = dict["country"] as! String
        let zip = dict["zip"] as! String
        let state = dict["state"] as! String
        return Location(city: city.isEmpty ? nil:city, country: country.isEmpty ? nil:country, state: state.isEmpty ? nil:state, zip: zip.isEmpty ? nil:zip)
    }
    
    func valid() -> Bool {
        return !(self.city == nil || self.country == nil || self.state == nil || self.zip == nil)
    }
}

extension Location: CustomStringConvertible {
    var description: String {
        return "\(city ?? ""), \(state ?? ""), \(zip ?? "")"
    }
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return
            lhs.city == rhs.city &&
                lhs.country == rhs.country &&
                lhs.state == rhs.state
    }
}

struct Trail {
    var from:Position?
    var destination:Position?
    var path:[Position]?
}

extension Trail:CustomStringConvertible {
    var description: String {
        var d = "From \(self.from) to \(self.destination) by"
        path?.forEach {
            d += "|\($0)| ->\n"
        }
        return d
    }
}
