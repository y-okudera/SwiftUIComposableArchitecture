//
//  Cards.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/10.
//

import Foundation

struct Cards: Decodable, Equatable, Identifiable {
  var id = UUID()
  var cards: [Card]

  enum CodingKeys: String, CodingKey {
    case cards
  }
}

// MARK: Mock

extension Cards {
  static var mock: Cards {
    Cards(
      cards: [
        Card.mock1,
        Card.mock2
      ]
    )
  }
}
