//
//  ViewController.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let retrieve = RetrieveEasypostData()
    
    let apiKEy = InitializeEasypostAPIKey()
    
    let shippo = ShippoTest()
    
    let coords = CoordinatesFromCityStateCountry()
    
    let date = DateModifier()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        shippo.track(trackingCode: "9205590164917312751089", carrierCall: "usps")
        
        //coords.getCoords(address: "Saratoga, CA, US")
        
        //print(date.getDaysLeft(estDate: "2017-02-22T00:00:00Z"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

