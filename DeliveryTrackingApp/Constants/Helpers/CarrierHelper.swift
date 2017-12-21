//
//  CarrierHelper.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/17/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation

internal struct RegexCarrier {
    let regex:String!
    let carrier:Carrier!
}

enum CarrierHelper {
    
    static let regexCarriers:[RegexCarrier] = [
        RegexCarrier(regex: "^\\d{22}$", carrier: .fedex),
        RegexCarrier(regex: "^\\d{20}$", carrier: .fedex),
        RegexCarrier(regex: "^\\d{10}$", carrier: .usps),
        RegexCarrier(regex: "^1Z[0-9A-Z]{16}$", carrier: .ups),
        RegexCarrier(regex: "^(H|T|J|K|F|W|M|Q|A)\\d{10}$", carrier: .ups),
        RegexCarrier(regex: "^\\d{12}$", carrier: .fedex),
        RegexCarrier(regex: "^\\d{15}$", carrier: .fedex),
        RegexCarrier(regex: "^02\\d{18}$", carrier: .fedex),
        RegexCarrier(regex: "^DT\\d{12}$", carrier: .fedex),
        RegexCarrier(regex: "^6129\\d{16}$", carrier: .fedex),
        RegexCarrier(regex: "^7489\\d{16}$", carrier: .fedex),
        RegexCarrier(regex: "^96\\d{20}$", carrier: .fedex),
        RegexCarrier(regex: "^(91|92|93|94|95|96)\\d{20}$", carrier: .usps),
        RegexCarrier(regex: "^(91|92|93|94|95|96)\\d{20}$", carrier: .usps),
        RegexCarrier(regex: "^\\d{26}$", carrier: .usps),
        RegexCarrier(regex: "^[A-Z]{2}\\d{9}US$", carrier: .usps),
        RegexCarrier(regex: "^(C|D)\\d{14}$", carrier: .ontrac),
        RegexCarrier(regex: "^L[A-Z]\\d{8}$", carrier: .lasership),
        RegexCarrier(regex: "^1LS\\d{12}$", carrier: .lasership),
        RegexCarrier(regex: "^Q\\d{8}[A-Z]$", carrier: .lasership),
        RegexCarrier(regex: "^[A-Z]{2}\\d{9}CA$", carrier: .canadaPost),
        RegexCarrier(regex: "^\\d{16}$", carrier: .canadaPost),
        RegexCarrier(regex: "^[A-Z]{2}\\d{9}AU$", carrier: .australiaPost),
        RegexCarrier(regex: "^\\[0-9A-Z]{13}$", carrier: .usps),
        RegexCarrier(regex: "^\\d{20}$", carrier: .usps),
        RegexCarrier(regex: "^\\d{30}$", carrier: .usps)
    ]
    
    static func guesses(from: String) -> [(Int,Carrier)] {
        var guessDictionary:[Carrier:(Int,Carrier)] = [:]
        regexCarriers.filter({ from =~ $0.regex }).forEach {
            if let (count,_) = guessDictionary[$0.carrier] {
                guessDictionary[$0.carrier] = (count + 1,$0.carrier)
            } else {
                guessDictionary[$0.carrier] = (1,$0.carrier)
            }
        }
        print("Array(guessDictionary.values): \(Array(guessDictionary.values))")
        return Array(guessDictionary.values).sorted(by: { c1,c2 in
            return c1.0 > c2.0
        })
    }
    
    static func guess(from s: String,be carrier: Carrier) -> Bool {
        return guesses(from:s).contains { $0.1 == carrier }
    }
}

