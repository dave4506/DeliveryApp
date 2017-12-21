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
import RxSwift

enum DelegateHelper {
    static func connectionObservable() -> Observable<ConnectionState> {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.connectionModel!.stateVar.asObservable();
    }
    
    static func connectionState() -> ConnectionState {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.connectionModel!.stateVar.value;
    }
    
    static func readNotification(for id:PackageId) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if let _ = delegate.notificationModel.notificationIndictorStatuses[id] {
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1
        }
        delegate.notificationModel.notificationIndictorStatuses.removeValue(forKey: id)
    }
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
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

extension String {
    func sanitize(string:String) -> String {
        return self.replacingOccurrences(of: string, with: "", options: .literal, range: nil)
    }
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    
    func sanitizeForStorage() -> String {
        return removeCharacters(from: ".#$[]/")
    }
}
