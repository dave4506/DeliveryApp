//
//  UIHelper.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/9/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit
import AssistantKit

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

struct SimpleTableData {
    var title:String!
    var description:String!
}

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.rangeAt($0).location != NSNotFound
                ? nsString.substring(with: result.rangeAt($0))
                : ""
            }
        }
    }
}

infix operator =~

func =~ (input: String, pattern: String) -> Bool {
    return input.matchingStrings(regex: pattern).count > 0
}

struct KeyWordSearch {
    let words:[String]!
    func match(string:String) -> Bool {
        guard words.count != 0 else { return false }
        var matched = true
        words.forEach { word in
            if !string.lowercased().contains(word) {
                matched = false
            }
        }
        return matched
    }
    static func searchMany(keywordSearches:[KeyWordSearch],string:String) -> Bool {
        guard keywordSearches.count != 0 else { return false }
        var matched = false
        keywordSearches.forEach { ks in
            if matched == false {
                matched = ks.match(string: string)
            }
        }
        return matched
    }
}

extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}
