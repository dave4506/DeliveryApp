//
//  PackageSettingsViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/9/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import Firebase

class SplitViewModel {
    
    let firstTimeVar = Variable<Bool>(true)
    let disposeBag = DisposeBag()

    func checkFirstTime() {
        guard firstTimeVar.value != false else { return }
        firstTimeVar.value = firstTimeVar.value
        firstTimeVar.value = !firstTimeVar.value
    }
    
    init() {
        
    }
    
    deinit {
    }
}
