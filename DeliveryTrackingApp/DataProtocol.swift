//
//  DataProtocol.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/16/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift

protocol RawData {
}

protocol Convertible:RawData {
    associatedtype ObjectType = Self
    static func convert(dict:[String:AnyObject]) -> ObjectType
}

protocol ManyConvertible:RawData {
    associatedtype ObjectType = Self
    static func convert(dict:[String:AnyObject]) -> [ObjectType]
}

protocol EnumConvertible:RawData {
    associatedtype ObjectType = Self
    static func convert(str:String) -> ObjectType
}

protocol RawDataConvertible:RawData {
    associatedtype ObjectType = Self
    associatedtype Data:RawData
    static func convert(data:Data) -> Observable<ObjectType>
}

protocol RawDataConvertibleOptional:RawData {
    associatedtype ObjectType = Self
    associatedtype Data:RawData
    static func convert(data:Data) -> Observable<ObjectType?>
}

protocol RawChange {
}

protocol CreateData {
}

typealias RawChanges = [RawChange]
