//
//  Shippo.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/5/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class ShippoModel {
    static func pullPackage(package:Package!) -> Observable<[String: AnyObject]?> {
        return RxAlamofire.requestJSON(.get, "\(Url.shippoTracking)/\(Carrier.convert(from: package.carrier))/\(package.trackingNumber)", parameters: [:], encoding: URLEncoding.default, headers: ["Authorization":"ShippoToken \(Api.shippoProduction)"]).map({ (r,json) -> [String: AnyObject]? in
            if let dict = json as? [String: AnyObject] {
                return dict
            } else {
                return nil
            }
        })
    }
}
