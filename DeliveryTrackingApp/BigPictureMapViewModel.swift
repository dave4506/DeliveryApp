//
//  BigPictureMapViewModel.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/28/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase


#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


class BigPictureMapViewModel {

    var ref:FIRDatabaseReference?
    
    let firebaseHandlerModel = FirebaseHandler()
    
    var databaseHandle:FIRDatabaseHandle?
    
    var dirtyPackageFromFirebase = [Any]()
    
    let firebaseDatabaseRxSwift = FIRDatabaseQuery()
    
    enum BigPictureState{
        case empty
        case fetching
        case contentsNowAvailable
    }
    
    func getStuff(){
        
        
        self.ref = FIRDatabase.database().reference()
        self.databaseHandle = self.ref?.child("users").child(self.firebaseHandlerModel.getCurrentUser_userID()).child("current_traccking_list").observe(.childAdded, with: {(snapshot) in
            
            let dirtyPackage = snapshot.value
            
            if dirtyPackage != nil {
                
                print(snapshot.value!)
                
            }
            
        })

    
    }
    func tryThisShit(){
    
       

    }
    
   
}


