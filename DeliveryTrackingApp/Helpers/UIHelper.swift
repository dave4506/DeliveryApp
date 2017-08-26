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

extension UIViewController {
    func setGradientContraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,bottomConstraint,topConstraint])
        view.layoutIfNeeded()
    }
    func setFABButtonConstraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -20)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: -20)
        NSLayoutConstraint.activate([widthConstraint,trailingConstraint,bottomConstraint,heightConstraint])
        view.layoutIfNeeded()
    }
    
    func setPageViewIndicatorConstraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        let xConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([widthConstraint,xConstraint,bottomConstraint,heightConstraint])
        view.layoutIfNeeded()
    }
}
