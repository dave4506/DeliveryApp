//
//  WalkThroughViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 3/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

class WalkThroughViewModel{
    
    let firebaseHandler = FirebaseHandler()
    
    var walkthruBool = false
    
    
    //returns true if walkthru is needed. Returns false if there is already a current user which means they have already seen walkthru
    func checkCurrentFirebaseUserForWalkThruStatus() -> Bool{
        
        var userInfo: FirebaseHandler.FirebaseUser
        
        userInfo = self.firebaseHandler.checkCurrentUser()
        
        switch userInfo {
        case .newUser:
            firebaseHandler.createNewAnonUser()
            walkthruBool = true
        case .returningUser:
            print(firebaseHandler.welcomeReturningUser())
        case .error:
            print("Error Shit")
        }
        return walkthruBool
    
    }
    
    


}
