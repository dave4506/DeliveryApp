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

struct Position {
    let lat:Double!
    let long:Double!
    func convertToCLLocationCordinate2d() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    static func convert(location:Location) -> Observable<Position?> {
        return Observable.create { observer in
            CLGeocoder().geocodeAddressString(location.description, completionHandler: { (placemarks, error) in
                if let error = error {
                    observer.onError(error)
                }
                if let coords = placemarks?.first?.location?.coordinate {
                    observer.onNext(Position(lat:coords.latitude,long:coords.longitude))
                } else {
                    observer.onNext(nil)
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
        return !(self.city == nil || self.country == nil || self.state == nil)
    }
}

extension Location: CustomStringConvertible {
    var description: String {
        return "!\(city ?? ""), \(state ?? ""), \(country), \(zip ?? "")!"
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
    
    static func generateMapTrails(dict:[String:AnyObject]) -> Observable<Trail?> {
        guard PrettyPackage.testValidDict(dict: dict) == .valid else { return Observable.just(nil) }
        return Position.convert(location: Location.convert(dict: dict["address_from"] as! [String:AnyObject])).flatMap { from -> Observable<Trail> in
            if let to = dict["address_to"] as? [String:AnyObject] {
                return Position.convert(location: Location.convert(dict:to)).flatMap {
                    return Observable<Trail>.just(Trail(from:from,destination:$0,path:[]))
                }
            } else {
                return Observable<Trail>.just(Trail(from:from,destination:nil,path:[]))
            }
            }.flatMap { trail -> Observable<Trail?> in
                let trackingHistory = dict["tracking_history"] as! [[String:AnyObject]]
                var locations = trackingHistory.map { Location.convert(dict: $0["location"] as! [String:AnyObject]) }
                locations.insert(Location.convert(dict: dict["address_from"] as! [String:AnyObject]), at: 0)
                var sanitizedlocations:[Location] = []
                if let first = locations.first {
                    sanitizedlocations.append(first)
                }
                locations.forEach {
                    let last = sanitizedlocations.last ?? $0
                    if last != $0 {
                        sanitizedlocations.append($0)
                    }
                }
                sanitizedlocations = sanitizedlocations.filter { $0.valid() }
                return Observable.from(sanitizedlocations).flatMap { location in
                    return Position.convert(location: location).flatMap { pos -> Observable<(Position,Int)> in
                        return Observable.just((pos!,Int(sanitizedlocations.index(of: location)!)))
                    }
                    }.toArray().flatMap { pathTuples -> Observable<Trail?> in
                        let sortedTuples = pathTuples.sorted(by: { $0.1 < $1.1 })
                        let path = sortedTuples.map { $0.0 }
                        return Observable<Trail?>.just(Trail(from:trail.from,destination:trail.destination,path:path))
                }
        }
    }
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
