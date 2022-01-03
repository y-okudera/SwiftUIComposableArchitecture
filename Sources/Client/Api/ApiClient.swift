//
//  ApiClient.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/12.
//

import Combine
import ComposableArchitecture
import Models

public struct ApiClient {
  public var cardsPage: (_ number: Int, _ size: Int) -> Effect<Cards, ApiError>
}

// MARK: - Mock

extension ApiClient {
  public static func mock(all: @escaping (Int, Int) -> Effect<Cards, ApiError> = { _, _ in fatalError("Unmocked") }) -> Self {
    Self(
      cardsPage: all
    )
  }

  public static func mockPreview(all: @escaping (Int, Int) -> Effect<Cards, ApiError> = { _, _ in .init(value: Cards.mock) }) -> Self {
    Self(
      cardsPage: all
    )
  }
}
