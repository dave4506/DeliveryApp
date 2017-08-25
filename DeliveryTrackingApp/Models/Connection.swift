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

enum ConnectionState {
    case connected, unintiated, disconnected
}

class ConnectionModel {
    let disposeBag = DisposeBag()
    let connectionState = Variable<ConnectionState>(.unintiated)
    var connectionHandler:DatabaseHandle?
    let ref =  Database.database().reference(withPath: ".info/connected")
    init() {
        startConnectionMonitor()
    }
    
    func startConnectionMonitor() {
        connectionHandler = ref.observe(.value, with: { [unowned self] snapshot in
            if snapshot.value as? Bool ?? false {
                self.connectionState.value = .connected
            } else {
                self.connectionState.value = .disconnected
            }
        })
    }
    
    deinit {
         ref.removeObserver(withHandle: connectionHandler!)
    }
}
