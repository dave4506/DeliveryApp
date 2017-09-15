
  //CarrierPretty.swift
 // DeliveryTrackingApp

 // Created by Pranav Madanahalli on 22717.
 // Copyright © 2017 Download Horizons. All rights reserved.


import Foundation

internal struct RegexCarrier {
    let regex:String!
    let carrier:Carrier!
}

enum Carrier {
    case unknown, australiaPost, asendiaUs, canadaPost, dhlGermany, dhlEcommerce, dhlExpress, fedex, glsGermany, glsFrance, hermesUK, lasership, mondialRelay, newgistics, ontrac, purolator, ups, usps, deutschePost

    static let regexCarriers:[RegexCarrier] = [
        RegexCarrier(regex: "\\d{20}$", carrier: .usps),
        RegexCarrier(regex: "(91|92|93|94|95|96)\\d{20}$", carrier: .usps),
        RegexCarrier(regex: "\\d{26}$", carrier: .usps),
        RegexCarrier(regex: "[A-Z]{2}\\d{9}US", carrier: .usps),
        RegexCarrier(regex: "1Z[0-9A-Z]{16}$", carrier: .ups),
        RegexCarrier(regex: "(H|T|J|K|F|W|M|Q|A)\\d{10}$", carrier: .ups),
        RegexCarrier(regex: "\\d{12}$", carrier: .fedex),
        RegexCarrier(regex: "\\d{15}$", carrier: .fedex),
        RegexCarrier(regex: "\\d{20}$", carrier: .fedex),
        RegexCarrier(regex: "02\\d{18}$", carrier: .fedex),
        RegexCarrier(regex: "DT\\d{12}$", carrier: .fedex),
        RegexCarrier(regex: "6129\\d{16}$", carrier: .fedex),
        RegexCarrier(regex: "7489\\d{16}$", carrier: .fedex),
        RegexCarrier(regex: "96\\d{20}$", carrier: .fedex),
        RegexCarrier(regex: "(C|D)\\d{14}$", carrier: .ontrac),
        RegexCarrier(regex: "L[A-Z]\\d{8}$", carrier: .lasership),
        RegexCarrier(regex: "1LS\\d{12}", carrier: .lasership),
        RegexCarrier(regex: "Q\\d{8}[A-Z]", carrier: .lasership),
        RegexCarrier(regex: "[A-Z]{2}\\d{9}CA", carrier: .canadaPost),
        RegexCarrier(regex: "\\d{16}$", carrier: .canadaPost),
        RegexCarrier(regex: "[A-Z]{2}\\d{9}AU", carrier: .australiaPost),
    ]
    
    static func guess(from: String) -> [(Int,Carrier)] {
        var guessDictionary:[Carrier:(Int,Carrier)] = [:]
        regexCarriers.filter({ from =~ $0.regex }).forEach {
            if let (count,_) = guessDictionary[$0.carrier] {
                guessDictionary[$0.carrier] = (count + 1,$0.carrier)
            } else {
                guessDictionary[$0.carrier] = (1,$0.carrier)
            }
        }
        return Array(guessDictionary.values)
    }
    
    static func convert(from strCarrier: String) -> Carrier {
        switch strCarrier {
        case "australia_post":
            return .australiaPost
        case "asendia_us":
            return .asendiaUs
        case "canada_post":
            return .canadaPost
        case "dhl_germany":
            return .dhlGermany
        case "dhl_ecommerce":
            return .dhlEcommerce
        case "dhl_express":
            return .dhlExpress
        case "fedex":
            return .fedex
        case "gls_de":
            return .glsGermany
        case "gls_fr":
            return .glsFrance
        case "hermes_uk":
            return .hermesUK
        case "lasership":
            return .lasership
        case "newgistics":
            return .newgistics
        case "ontrac":
            return .ontrac
        case "purolator":
            return .purolator
        case "deutsche_post":
            return .deutschePost
        case "ups":
            return .ups
        case "usps":
            return .usps
        default:
            return .unknown
        }
    }
    
    static func convert(from carrier: Carrier) -> String {
        switch carrier {
        case .australiaPost :
            return "australia_post"
        case .asendiaUs:
            return "asendia_us"
        case .canadaPost:
            return "canada_post"
        case .dhlGermany:
            return "dhl_germany"
        case .dhlEcommerce:
            return "dhl_ecommerce"
        case .dhlExpress:
            return "dhl_express"
        case .fedex:
            return "fedex"
        case .glsGermany:
            return "gls_de"
        case .glsFrance:
            return "gls_fr"
        case .hermesUK:
            return "hermes_uk"
        case .lasership:
            return "lasership"
        case .newgistics:
            return "newgistics"
        case .ontrac:
            return "ontrac"
        case .purolator:
            return "purolator"
        case .deutschePost:
            return "deutsche_post"
        case .ups:
            return "ups"
        case .usps:
            return "usps"
        default:
            return "unknown"
        }
    }
}

extension Carrier: CustomStringConvertible {
    var description: String {
        switch self {
        case .australiaPost:
            return "Australia Post"
        case .asendiaUs:
            return "Asendia US"
        case .canadaPost:
            return "Canada Post"
        case .dhlGermany:
            return "DHL Germany"
        case .dhlEcommerce:
            return "DHL Ecommerce"
        case .dhlExpress:
            return "DHL Express"
        case .fedex:
            return "Fedex"
        case .glsGermany:
            return "GLS Germany"
        case .glsFrance:
            return "GLS France"
        case .hermesUK:
            return "Hermes UK"
        case .lasership:
            return "Lasership"
        case .newgistics:
            return "Newgistics"
        case .ontrac:
            return "Ontrac"
        case .purolator:
            return "Purolator"
        case .deutschePost:
            return "Deutsche Post"
        case .ups:
            return "UPS"
        case .usps:
            return "USPS"
        default:
            return "No Clue"
        }
    }
}

extension Carrier {
    static func convertToUrlString(carrier:Carrier,trackingNum:String) -> String? {
        switch carrier {
        case .australiaPost:
            return "https://auspost.com.au/parcels-mail/track.html#/track?id=\(trackingNum)"
        case .asendiaUs:
            return "http://tracking.asendiausa.com/t.aspx?p=\(trackingNum)"
        case .canadaPost:
            return "http://www.canadapost.ca/cpotools/apps/track/personal/findByTrackNumber?trackingNumber=\(trackingNum)&LOCALE=en"
        case .dhlGermany:
            return "https://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=en&idc=\(trackingNum)"
        case .dhlEcommerce:
            return "https://webtrack.dhlglobalmail.com/?trackingnumber=\(trackingNum)"
        case .dhlExpress:
            return "http://www.dhl.com/en/express/tracking.html?brand=DHL&AWB=\(trackingNum)"
        case .fedex:
            return "https://www.fedex.com/apps/fedextrack/?tracknumbers=\(trackingNum)"
        case .glsGermany:
            return "https://gls-group.eu/EU/en/parcel-tracking?match=\(trackingNum)"
        case .glsFrance:
            return "https://gls-group.eu/EU/en/parcel-tracking?match=\(trackingNum)"
        case .hermesUK:
            return "https://www.myhermes.co.uk/tracking-results.html?trackingNumber=\(trackingNum)"
        case .lasership:
            return "http://www.lasership.com/track.php?track_number_input=\(trackingNum)"
        case .newgistics:
            return "http://tracking.smartlabel.com/default.aspx?trackingvalue=\(trackingNum)"
        case .ontrac:
            return "http://www.ontrac.com/trackingdetail.asp?tracking=\(trackingNum)"
        case .purolator:
            return "https://www.purolator.com/purolator/ship-track/tracking-summary.page?pin=\(trackingNum)"
        case .deutschePost:
            return "https://www.deutschepost.de/sendung/simpleQuery.html"
        case .ups:
            return "http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=\(trackingNum)"
        case .usps:
            return "https://tools.usps.com/go/TrackConfirmAction?tLabels=\(trackingNum)"
        default:
            return nil
        }
    }
}
