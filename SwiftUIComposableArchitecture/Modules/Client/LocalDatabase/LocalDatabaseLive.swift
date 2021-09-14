//
//  LocalDatabaseLive.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/12.
//

import ComposableArchitecture
import GRDB

// MARK: - Live

extension LocalDatabaseClient {
  static let live = Self(
    migrate: {
      do {
        var migrator = DatabaseMigrator()

        // 1st migration
        migrator.registerMigration("v1") { db in
          try db.create(table: FavoriteCard.databaseTableName) { tableDefinition in
            tableDefinition.column("id", .text).notNull()
            tableDefinition.column("name", .text).notNull()
            tableDefinition.column("hp", .text)
            tableDefinition.column("imageURLString", .text).notNull()
            tableDefinition.column("imageHDURLString", .text).notNull()
          }
        }

        let queue = try DatabaseQueue(path: databasePath.absoluteString)
        try migrator.migrate(queue)

        return .init(value: ())
      } catch {
        assertionFailure("migration error has occurred: \(error)")
        return .init(error: error)
      }
    },
    fetchFavoriteCards: {
      fetchAllFavoriteCards()
    },
    insertFavoriteCard: { card in
      guard !hasFavorite(with: card) else {
        return fetchAllFavoriteCards()
      }
      do {
        let dbQueue = try DatabaseQueue(path: databasePath.absoluteString)
        try dbQueue.write { db in
          var favoriteCard = FavoriteCard(card: card)
          try favoriteCard.save(db)
        }
      } catch {
        assertionFailure("error saving favorites: \(error)")
        return fetchAllFavoriteCards()
      }
      return fetchAllFavoriteCards()
    },
    deleteFavoriteCard: { card in
      guard hasFavorite(with: card) else {
        return fetchAllFavoriteCards()
      }

      do {
        let dbQueue = try DatabaseQueue(path: databasePath.absoluteString)
        try dbQueue.write { db in
          let favoriteCard = FavoriteCard(card: card)
          try favoriteCard.delete(db)
        }
      } catch {
        assertionFailure("error deleting favorites: \(error)")
        return fetchAllFavoriteCards()
      }
      return fetchAllFavoriteCards()
    }
  )

  static let databasePath = FileManager
    .default
    .urls(for: .documentDirectory, in: .userDomainMask)
    .first!
    .appendingPathComponent("application.sqlite")

  private static func fetchAllFavoriteCards() -> Effect<[Card], Never> {
    do {
      let dbQueue = try DatabaseQueue(path: databasePath.absoluteString)
      let favorites: [FavoriteCard] = try dbQueue.read { db in
        try FavoriteCard.fetchAll(db)
      }
      return .init(value: favorites.map { Card(with: $0) })
    } catch {
      assertionFailure("error retrieving favorites: \(error)")
      return .init(value: [])
    }
  }

  private static func hasFavorite(with card: Card) -> Bool {
    do {
      let dbQueue = try DatabaseQueue(path: databasePath.absoluteString)
      let hasFavorite: Bool = try dbQueue.read { db in
        let favoriteCardWithIdCount: Int = try FavoriteCard
          .filter(Column("id") == card.id)
          .fetchCount(db)
        return favoriteCardWithIdCount > 0
      }
      return hasFavorite
    } catch {
      assertionFailure("error retrieving favorites: \(error)")
      return false
    }
  }
}
