//
//  Networking.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/17/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Firebase

enum DataModelState<T> {
    case unintiated, loaded(T), error(Error), loading, empty
}

protocol State {
    
}

protocol StateWatcher {
    var stateVar: Variable<DataModelState<Data>> { get } 
    var disposeBag: Disposebag { get }
    var handler: DatabaseHandle { get set }
    var ref: DatabaseReference { get set }
    
    func watch()
    func stop()
}
