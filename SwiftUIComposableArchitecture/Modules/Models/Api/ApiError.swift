//
//  ApiError.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Foundation

enum ApiError: Error {
  case network(error: Error)
  case decoding(error: Error)
}

extension ApiError: Equatable {
  static func == (lhs: ApiError, rhs: ApiError) -> Bool {
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
