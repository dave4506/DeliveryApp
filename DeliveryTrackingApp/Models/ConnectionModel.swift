//
//  ConnectionModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class ConnectionModel:StateWatcher {
    let disposeBag = DisposeBag()
    let stateVar = Variable<ConnectionState>(.unintiated)
    var handler:DatabaseHandle?
    let ref =  Database.database().reference(withPath: ".info/connected")
    
    var firstTime = true
    
    init() {
        start()
    }
    
    func start() {
        handler = ref.observe(.value, with: { [unowned self] snapshot in
            if snapshot.value as? Bool ?? false {
                self.stateVar.value = .connected
            } else {
                if self.firstTime {
                    self.stateVar.value = .disconnected
                    self.firstTime = false
                } else {
                    self.stateVar.value = .disconnected
                }
            }
        })
    }
    
    func stop() {
        ref.removeObserver(withHandle: connectionHandler!)
    }
    
    deinit {
        stop()
    }
}
