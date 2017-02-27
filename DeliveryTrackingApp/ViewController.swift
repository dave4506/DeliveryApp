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
    
    
    let firebaseHandler = FirebaseHandler()
    

    let addnewPackageViewModel = AddNewPackageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userInfo: FirebaseHandler.FirebaseUser

        userInfo = self.firebaseHandler.checkCurrentUser()
        
        switch userInfo {
        case .newUser:
            firebaseHandler.createNewAnonUser()
        case .returningUser:
            print(firebaseHandler.welcomeReturningUser())
        case .error:
            print("Error Shit")
        }
        
        


        
    }

    @IBAction func trackPackage(_ sender: Any) {
        
        addnewPackageViewModel.trackNewPackage(trackingCode: "9205590164917312751089", carrier: "usps", nameOfPackage: "Books", notification: 1)
        
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

