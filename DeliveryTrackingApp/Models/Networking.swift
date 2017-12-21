//
//  Networking.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/17/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

enum DataModelState<T> {
    case unintiated, loaded(T), error(Error), loading, empty
}

protocol State {
    
}

protocol StateWatcher {
    associatedtype StateWatched:State
    var stateVar: Variable<StateWatched> { get }
    var disposeBag: DisposeBag { get }
    var handler: DatabaseHandle? { get set }
    var ref: DatabaseReference { get }
    
    func watch()
    func stop()
}
