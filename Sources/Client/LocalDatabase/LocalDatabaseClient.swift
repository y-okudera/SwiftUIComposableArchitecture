//
//  LocalDatabaseClient.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture
import Models
import RealmSwift

public struct LocalDatabaseClient {
  static var realm: Realm?
  public var fetchFavoriteCards: () -> Effect<[Card], Never>
  public var insertFavoriteCard: (_ card: Card) -> Effect<[Card], Never>
  public var deleteFavoriteCard: (_ card: Card) -> Effect<[Card], Never>

  init(
    fetchFavoriteCards: @escaping () -> Effect<[Card], Never>,
    insertFavoriteCard: @escaping (Card) -> Effect<[Card], Never>,
    deleteFavoriteCard: @escaping (Card) -> Effect<[Card], Never>
  ) {
    let config = Realm.Configuration(schemaVersion: 1)
    Realm.Configuration.defaultConfiguration = config
    Self.realm = Self.realm == nil ? try? Realm() : Self.realm

    print("Realm file path", Self.realm?.configuration.fileURL ?? "")

    self.fetchFavoriteCards = fetchFavoriteCards
    self.insertFavoriteCard = insertFavoriteCard
    self.deleteFavoriteCard = deleteFavoriteCard
  }
}

// MARK: - Mock

extension LocalDatabaseClient {
  public static func mock(
    fetchFavoriteCards: @escaping () -> Effect<[Card], Never> = { fatalError("Unmocked") },
    insertFavoriteCard: @escaping (Card) -> Effect<[Card], Never> = { _ in fatalError("Unmocked") },
    deleteFavoriteCard: @escaping (Card) -> Effect<[Card], Never> = { _ in fatalError("Unmocked") }
  ) -> Self {
    Self(
      fetchFavoriteCards: fetchFavoriteCards,
      insertFavoriteCard: insertFavoriteCard,
      deleteFavoriteCard: deleteFavoriteCard
    )
  }

  public static func mockPreview(
    fetchFavoriteCards: @escaping () -> Effect<[Card], Never> = { .init(value: [Card.mock1]) },
    insertFavoriteCard: @escaping (Card) -> Effect<[Card], Never> = { _ in .init(value: [Card.mock2]) },
    deleteFavoriteCard: @escaping (Card) -> Effect<[Card], Never> = { _ in .init(value: []) }
  ) -> Self {
    Self(
      fetchFavoriteCards: fetchFavoriteCards,
      insertFavoriteCard: insertFavoriteCard,
      deleteFavoriteCard: deleteFavoriteCard
    )
  }
}
