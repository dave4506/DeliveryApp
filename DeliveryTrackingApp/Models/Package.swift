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

struct Package:RawData {
    var id: String
    var trackingNumber: String
    var carrier: Carrier
    var title: String
    var status: PackageState = .uninitialized
    var trackingDetailsDict: [String:AnyObject]?
    var notificationStatus:NotificationTiers
    var archived: Bool
    var cacheReadTimeStamp: Int?
}

extension Package:Convertible {
    static func convert(dict:[String:AnyObject]) -> Package {
        return Package(
            id: dict["id"] as! String,
            trackingNumber: dict["tracking_number"] as! String,
            carrier: Carrier.convert(dict["carrier"] as! String),
            title: dict["title"] as! String,
            status: .uninitialized,
            trackingDetailsDict: dict["tracking_details"] as? [String:AnyObject],
            notificationStatus: NotificationTiers.convert(dict["notification_status"] as! String),
            archived:dict["archived"] as! Bool,
            cacheReadTimeStamp:dict["cache_read_time"] as? Int
        )
    }
}

/*
extension Package {
    
    internal enum PackageDictType {
    case invalid, valid, offline
    }

    static func pull(id:String) -> Observable<PrettyPackage?> {
        return Package.pullPackageDetails(id: id).map { pack -> Package? in
            if let pack = pack {
                return Package.convert(dict:pack)
            } else {
                return nil
            }
        }.flatMap { pack -> Observable<([String : AnyObject]?, (Package))?> in
            if let pack = pack {
                return Package.pullTrackingDetails(pack:pack).map {
                    return ($0,pack)
                }
            } else {
                return Observable<([String : AnyObject]?, (Package))?>.just(nil)
            }
        }.map { d -> PrettyPackage? in
            guard let d = d else { return nil }
            guard let dict = d.0 else { return nil }
            var package = d.1
            package.trackingDetailsDict = dict
            return PrettyPackage.convert(package: package)
        }
    }
    
    static func pullTrackingDetails(pack:Package)-> Observable<[String:AnyObject]?> {
        return  Package.pullTrackingCache(id: pack.id).flatMap { d -> Observable<[String : AnyObject]?> in
            if let dict = d {
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
    
    static func pullTrackingCache(id:String) -> Observable<[String:AnyObject]?> {
        return Observable.create { observer in
            Database.database().reference(withPath: "/cache/\(id)").keepSynced(true)
            Database.database().reference(withPath: "/cache/\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
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
                print("error???/")
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
 */
