//
//  ModelProtocol..swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/16/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

protocol Model {
    associatedtype Data: RawData
    var dataVar: Variable<DataModelState<Data>> { get }
    var disposeBag: DisposeBag { get } 
}

protocol Pullable: Model {
    func pull()
}

protocol PullObservable: Model {
    func pullObservable() -> Observable<Data?>
}

protocol Deletable: Model {
    func delete()
}

protocol Creatable: Model {
    func create(rawData:Data)
}

protocol Changeable: Model {
    associatedtype Change: RawChange
    func change(changes:[Change])
}

protocol Watchable: Model {
    var handler: DatabaseHandle? { get set }
    var ref: DatabaseReference? { get set }
    
    func watch()
    func stop()
}
