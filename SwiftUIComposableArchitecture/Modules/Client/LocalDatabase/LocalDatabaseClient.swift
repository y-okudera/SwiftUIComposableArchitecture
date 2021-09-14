//
//  LocalDatabaseClient.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture
import GRDB

struct LocalDatabaseClient {
  var migrate: () -> Effect<Void, Error>
  var fetchFavoriteCards: () -> Effect<[Card], Never>
  var insertFavoriteCard: (_ card: Card) -> Effect<[Card], Never>
  var deleteFavoriteCard: (_ card: Card) -> Effect<[Card], Never>
}

// MARK: - Mock

extension LocalDatabaseClient {
  static func mock(
    migrate: @escaping () -> Effect<Void, Error> = { fatalError("Unmocked") },
    fetchFavoriteCards: @escaping () -> Effect<[Card], Never> = { fatalError("Unmocked") },
    insertFavoriteCard: @escaping (Card) -> Effect<[Card], Never> = { _ in fatalError("Unmocked") },
    deleteFavoriteCard: @escaping (Card) -> Effect<[Card], Never> = { _ in fatalError("Unmocked") }
  ) -> Self {
    Self(
      migrate: migrate,
      fetchFavoriteCards: fetchFavoriteCards,
      insertFavoriteCard: insertFavoriteCard,
      deleteFavoriteCard: deleteFavoriteCard
    )
  }

  static func mockPreview(
    migrate: @escaping () -> Effect<Void, Error> = { .result { .success(()) } },
    fetchFavoriteCards: @escaping () -> Effect<[Card], Never> = { .init(value: [Card.mock1]) },
    insertFavoriteCard: @escaping (Card) -> Effect<[Card], Never> = { _ in .init(value: [Card.mock2]) },
    deleteFavoriteCard: @escaping (Card) -> Effect<[Card], Never> = { _ in .init(value: []) }
  ) -> Self {
    Self(
      migrate: migrate,
      fetchFavoriteCards: fetchFavoriteCards,
      insertFavoriteCard: insertFavoriteCard,
      deleteFavoriteCard: deleteFavoriteCard
    )
  }
}
