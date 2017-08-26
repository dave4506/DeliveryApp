//
//  Package.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/23/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

enum PackageDictType {
    case invalid, valid, offline
}

struct Package {
    var id: String
    var trackingNumber: String
    var carrier: Carrier
    var title: String
    var status: PackageStatus = .unknown
    var trackingDetailsDict: [String:AnyObject]?
    var notificationStatus:NotificationStatus
    var archived: Bool
    var cacheReadTimeStamp: Int?
}

extension Package {
    
    static func pull(id:String) -> Observable<PrettyPackage?> {
        return Package.pullPackageDetails(id: id).map { pack in
            return Package.convPackageDictionary(pack!)
        }.flatMap { pack -> Observable<([String : AnyObject]?, (Package))> in
            return Package.pullTrackingDetails(pack:pack).map {
                return ($0,pack)
            }
        }.map { (dict,p) -> PrettyPackage? in
            guard let dict = dict else { return nil }
            var package = p
            package.trackingDetailsDict = dict
            return PrettyPackage.convert(package: package)
        }
    }

    static func convPackageDictionary(_ packDict:[String:AnyObject]) -> Package {
        return Package(id: packDict["id"] as! String,trackingNumber: packDict["tracking_number"] as! String, carrier: Carrier.convShippo(from: packDict["carrier"] as! String), title: packDict["title"] as! String, status: .unknown, trackingDetailsDict: nil,notificationStatus: NotificationStatus.convString(packDict["notification_status"] as! String),archived:packDict["archived"] as! Bool,cacheReadTimeStamp:packDict["cache_read_time"] as? Int)
    }
    
    static func pullTrackingDetails(pack:Package)-> Observable<[String:AnyObject]?> {
        return  Package.pullTrackingCache(tracking: pack.trackingNumber, carrier: pack.carrier,id: pack.id).flatMap { d -> Observable<[String : AnyObject]?> in
            if let dict = d {
                print("using Cache")
                let delegate = UIApplication.shared.delegate as! AppDelegate
                if PrettyPackage.testValidDict(dict: dict) == .offline && delegate.connectionModel?.connectionState.value == .connected {
                    return ShippoModel.pullPackage(package: pack)
                }
                return Observable.just(dict)
            } else {
                print("using Shippo Backup")
                return ShippoModel.pullPackage(package: pack)
            }
        }
    }
    
    static func pullTrackingCache(tracking:String,carrier:Carrier,id:String?) -> Observable<[String:AnyObject]?> {
        return Observable.create { observer in
            Database.database().reference(withPath: "/cache/\(Carrier.convBackShippo(from: carrier))/\(tracking)").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? [String:AnyObject], snapshot.exists() {
                    var latest = value["latest"] as? [String:AnyObject]
                    latest?["date_updated"] = value["date_updated"]
                    observer.on(.next(latest))
                    observer.onCompleted()
                } else {
                    observer.on(.next(nil))
                    observer.onCompleted()
                }
            }) { (error) in
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }
    
    static func pullPackageDetails(id:String) -> Observable<[String:AnyObject]?> {
        return Observable.create { observer in
            Database.database().reference(withPath: "/packages/\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
                if var value = snapshot.value as? [String:AnyObject], snapshot.exists() {
                    value["id"] = snapshot.key as AnyObject
                    observer.on(.next(value))
                    observer.onCompleted()
                } else {
                    observer.on(.next(nil))
                    observer.onCompleted()
                }
            }) { (error) in
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }
    
    static func pullUserPackages(uid:String) -> Observable<String> {
        return Observable.create { observer in
            let userPackagesRef = Database.database().reference(withPath: "/user_packages/\(uid)")
            userPackagesRef.observeSingleEvent(of:.value, with: { snapshot in
                let postPackages = snapshot.value as? [String:AnyObject] ?? [:]
                Array(postPackages.keys).forEach({
                    observer.on(.next($0))
                })
                observer.onCompleted()
            }) { (error) in
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }
}