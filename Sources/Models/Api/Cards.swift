//
//  Cards.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/10.
//

import Foundation

public struct Cards: Decodable, Equatable, Identifiable {
  public var id = UUID()
  public var cards: [Card]

  enum CodingKeys: String, CodingKey {
    case cards
  }
}

// MARK: Mock

public extension Cards {
  static var mock: Cards {
    Cards(
      cards: [
        Card.mock1,
        Card.mock2,
      ]
    )
  }
}
