//
//  RetrieveEasypostDataTests.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/1/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
@testable import DeliveryTrackingApp


class RetrieveEasypostDataTests: XCTestCase {
    
    let retrieveEasypostData = RetrieveEasypostData()
    
    let initAPIkey = InitializeEasypostAPIKey()
    override func setUp() {
        super.setUp()
        
        initAPIkey.setAndCheckAPIKeys()
        
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testsendToParseEasypostDataClass(){
        
        
        //XCTAssertTrue(retrieveEasypostData.sendToParseEasypostDataClass(jsonS: retrieveEasypostData.jsonTop), "HERE")
        
    }
    
    
    
}
