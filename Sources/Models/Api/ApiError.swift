//
//  ApiError.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Foundation

public enum ApiError: Error {
  case network(error: Error)
  case decoding(error: Error)
}

extension ApiError: Equatable {
  public static func == (lhs: ApiError, rhs: ApiError) -> Bool {
    switch (lhs, rhs) {
    case (.network(let lhsError), .network(let rhsError)):
      return ErrorUtility.areEqual(lhsError, rhsError)
    case (.decoding(let lhsError), .decoding(let rhsError)):
      return ErrorUtility.areEqual(lhsError, rhsError)
    default:
      return false
    }
  }
}

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
