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

// Location
struct Location:RawData {
    let city:String?
    let country: String?
    let state: String?
    let zip: String?
    
    func valid() -> Bool {
        return (self.city != nil)
    }
}

extension Location: Convertible {
    static func convert(dict:[String:AnyObject]) -> Location {
        let city = dict["city"] as! String
        let country = dict["country"] as! String
        let zip = dict["zip"] as! String
        let state = dict["state"] as! String
        return Location(city: city.isEmpty ? nil:city, country: country.isEmpty ? nil:country, state: state.isEmpty ? nil:state, zip: zip.isEmpty ? nil:zip)
    }
}

extension Location {
    private static let sanitizeWords = [
        "distribution",
        "regional",
        "facility",
        "center",
        "smartpost",
        "fedex"
    ]
    
    static func sanitize(address:String) -> String {
        var d = address.lowercased()
        Location.sanitizeWords.forEach {
            d = d.sanitize(string: $0)
        }
        return d
    }
}

extension Location: CustomStringConvertible {
    var description: String {
        return Location.sanitize(address: "\(city ?? "") \(state ?? "") \(country ?? "") \(zip ?? "")")
    }
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return
            lhs.city == rhs.city &&
                lhs.country == rhs.country &&
                lhs.state == rhs.state &&
                lhs.zip == rhs.zip
    }
}

// Position
struct Position:RawData {
    let lat:Double!
    let long:Double!
}

extension Position:RawDataConvertible {
    func convertToCLLocationCordinate2d() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    static func convert(data:Location) -> Observable<Position?> {
        guard data.valid() else { return Observable<Position?>.just(nil) }
        return Observable.create { observer in
            CLGeocoder().geocodeAddressString(data.description, completionHandler: { (placemarks, error) in
                if let _ = error {
                    observer.onNext(nil)
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

//Trail
struct TrailLocations:RawData {
    var from:Location?
    var destination:Location?
    var path:[Location]?
}

extension TrailLocations:Convertible {
    static func convert(dict:[String:AnyObject]) -> TrailLocations {
        return TrailLocations(
            from: dict["address_from"] != nil ? Location.convert(dict: dict["address_from"] as! [String:AnyObject]):nil,
            destination: dict["address_to"] != nil ? Location.convert(dict: dict["address_to"] as! [String:AnyObject]):nil,
            path: (dict["tracking_history"] as! [[String:AnyObject]]).map{ Location.convert(dict: $0["location"] as! [String:AnyObject]) }
        )
    }
}

struct Trail:RawData {
    var from:Position?
    var destination:Position?
    var path:[Position]?
}

extension Trail:RawDataConvertible {
    static func convert(data:TrailLocations) -> Observable<Trail> {
        let trailLocations = data
        return Observable<Trail?>.just(nil).flatMap { trail -> Observable<Trail> in
            var locations = trailLocations.path ?? []
            if let from = trailLocations.from {
                locations.insert(from, at: 0)
            }
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
            sanitizedlocations.forEach {
                print($0)
            }
            return Observable.from(sanitizedlocations).flatMap { location in
                return Position.convert(location: location).flatMap { pos -> Observable<(Position?,Int)> in
                    return Observable.just((pos,Int(sanitizedlocations.index(of: location)!)))
                }
                }.toArray().flatMap { pathTuples -> Observable<Trail> in
                    let sortedTuples = pathTuples.sorted(by: { $0.1 < $1.1 })
                    let path = sortedTuples.filter({ $0.0 != nil }).map { $0.0! }
                    return Observable<Trail>.just(Trail(from:nil,destination:nil,path:path))
            }
            }.flatMap { trail -> Observable<Trail> in
                if let from = trailLocations.from {
                    return Position.convert(location: from).flatMap {
                        return Observable<Trail>.just(Trail(from:$0,destination:nil,path:trail.path))
                    }
                } else {
                    return Observable<Trail>.just(Trail(from:nil,destination:nil,path:trail.path))
                }
            }.flatMap { trail -> Observable<Trail> in
                if let dest = trailLocations.destination {
                    return Position.convert(location: dest).flatMap {
                        return Observable<Trail>.just(Trail(from:trail.from,destination:$0,path:trail.path))
                    }
                } else {
                    return Observable<Trail>.just(Trail(from:trail.from,destination:nil,path:trail.path))
                }
        }
    }
}


extension Trail:CustomStringConvertible {
    var description: String {
        var d = path?.reduce("From \(String(describing: self.from)) to \(self.destination) by ") { (result,pos) in
                result += "|\(pos)| ->\n"
                return result
            } ?? ""
        return d
    }
}
