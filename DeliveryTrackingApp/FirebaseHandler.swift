//
//  FirebaseHandler.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


class FirebaseHandler {

    enum FirebaseUser{
        case newUser
        case returningUser
        case error
    }
    
    var firebase: FIRDatabaseReference?

    
    func checkCurrentUser() -> FirebaseUser {
        
        self.firebase = FIRDatabase.database().reference()
        
        if let user = FIRAuth.auth()?.currentUser {
            self.firebase!.child("users/\(user.uid)/userID").setValue(user.uid)
            
            return FirebaseUser.returningUser
            
        } else {
            return FirebaseUser.newUser
        }
    
    }
    func createNewAnonUser(){
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if error != nil {
                
            } else {
                self.firebase!.child("users").child(user!.uid).setValue(["userID": user!.uid])
                
            }
        })
    
    
    }
    func welcomeReturningUser() -> String {
        
        let user = FIRAuth.auth()?.currentUser
        return "Welcome back \(user!.uid)"
    
    
    }
    
    //returns true if user has already added a package before
    func isThereCurrentTrackingListUnderneathUser() -> Bool{
    
        return false
    
    }
    
    func initializeCurrentTrackingListInFirebase () {
    
    
    }
    
    func addPackageToCurrentTackingListInFirebase(dictionary: Dictionary<String, Any>) -> Bool{
        
        return true
        
    }
    
    func updateCurrentPackageList(current_tracking_list_unique_id: String) -> Bool{
        
        //puts each package item in Firebase into an Array Package.swift
        
        //calls trackPackage(trackingCode: String, carrierCall: String) from ShippotTest.swift which returns a dictionairy
            // deletes the old data from that Firebase Package and inserts the dictionary from the previous bullet
        
        return true
        
    }
    
    func updateCurrentPackage() {
        
    
    
    }
    
    
    
    
    
    
    
    
    

}
