//
//  LocalDatabaseLive.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/12.
//

import ComposableArchitecture
import Models
import RealmSwift

// MARK: - Live

extension LocalDatabaseClient {
  public static let live =
    Self(
      fetchFavoriteCards: {
        fetchAllFavoriteCards()
      },
      insertFavoriteCard: { card in
        guard favoriteCardObject(with: card) == nil else {
          return fetchAllFavoriteCards()
        }
        do {
          try realm?.write {
            let object = FavoriteCard(value: FavoriteCard(card: card))
            realm?.add(object)
          }
        } catch {
          assertionFailure("error saving favorites: \(error)")
          return fetchAllFavoriteCards()
        }

        return fetchAllFavoriteCards()
      },
      deleteFavoriteCard: { card in
        guard let favoriteCardObject = favoriteCardObject(with: card) else {
          return fetchAllFavoriteCards()
        }
        do {
          try realm?.write {
            realm?.delete(favoriteCardObject)
          }
        } catch {
          assertionFailure("error deleting favorites: \(error)")
          return fetchAllFavoriteCards()
        }
        return fetchAllFavoriteCards()
      }
    )

  private static func fetchAllFavoriteCards() -> Effect<[Card], Never> {
    guard let realm = self.realm else {
      return .init(value: [])
    }
    let favorites = realm.objects(FavoriteCard.self).map { FavoriteCard(value: $0) }
    let cards: [Card] = favorites.map { .init(with: $0) }
    return .init(value: cards)
  }

  private static func favoriteCardObject(with card: Card) -> FavoriteCard? {
    return realm?.object(ofType: FavoriteCard.self, forPrimaryKey: card.id)
  }
}
