//
//  ErrorUtility.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Foundation

enum ErrorUtility {
    static func areEqual(_ lhs: Error, _ rhs: Error) -> Bool {
        return lhs.reflectedString == rhs.reflectedString
    }
}

extension Error {
    var reflectedString: String {
        return String(reflecting: self)
    }

    func isEqual(to: Self) -> Bool {
        return reflectedString == to.reflectedString
    }
}

extension NSError {
    func isEqual(to: NSError) -> Bool {
        let lhs = self as Error
        let rhs = to as Error
        return isEqual(to) && lhs.reflectedString == rhs.reflectedString
    }
}
