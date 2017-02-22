//
//  ViewController.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class ViewController: UIViewController {
    
    let retrieve = RetrieveEasypostData()
    
    let apiKEy = InitializeEasypostAPIKey()
    
    let shippo = ShippoTest()
    
    var firebase: FIRDatabaseReference?

    let firebaseHandler = FirebaseHandler()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userInfo: FirebaseHandler.FirebaseUser

        userInfo = self.firebaseHandler.checkCurrentUser()
        
        switch userInfo {
        case .newUser:
            firebaseHandler.createNewAnonUser()
        case .returningUser:
            print(firebaseHandler.welcomeReturningUser())
            //update Firebase data by pulling from Shippo
        case .error:
            print("Error Shit")
        }
        


        
    }

    @IBAction func printShit(_ sender: Any) {
        
        
    }
    @IBAction func trackPackage(_ sender: Any) {
        
        let user = FIRAuth.auth()?.currentUser
        
        let key = firebase?.child("users").child(user!.uid).childByAutoId().key
        
        firebase?.child("users").child(user!.uid).setValue(["current_tracking_list" : key!])
        
        let key2 = firebase?.child("\(key!)").childByAutoId().key
        
        //let json = shippo.track(trackingCode: "9205590164917312751089", carrierCall: "usps")

        
        //firebase?.child("\(key!)").child("\(key2!)").setValue(json)
        
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

