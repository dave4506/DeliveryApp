//
//  CarrierPretty.swift
//  DeliveryTrackingApp
//
//  Created by Pranav Madanahalli on 2/27/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

class CarrierPretty{


    func prettyCarrier(carrier: String) -> String {
    
        switch carrier {
        case "australia_post":
            return "Australia Post"
        case "asendia_us":
            return "Asendia"
        case "canada_post":
            return "Canada Post"
        case "deutsche_post":
            return "Deutsche Post"
        case "dhl_germany":
            return "DHL Germany"
        case "dhl_ecommerce":
            return "DHL eCommerce"
        case "dhl_express":
            return "DHL Express"
        case "fedex":
            return "FedEx"
        case "gls_de":
            return "GLS Germany"
        case "gls_fr":
            return "GLS France"
        case "hermes_uk":
            return "Hermes UK"
        case "lasership":
            return "Lasership"
        case "mondial_relay":
            return "Mondial Relay"
        case "newgistics":
            return "Newgistics"
        case "ontrac":
            return "OnTrac"
        case "purolator":
            return "Purolator"
        case "ups":
            return "UPS"
        case "usps":
            return "USPS"
        default:
            return carrier
        }
    }
    
    
}
