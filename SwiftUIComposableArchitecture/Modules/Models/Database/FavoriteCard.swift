//
//  FavoriteCard.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Foundation
import GRDB

struct FavoriteCard: Codable, MutablePersistableRecord, FetchableRecord {
  static var databaseTableName: String {
    return "favorite_cards"
  }

  var id: String
  var name: String
  var hp: String?
  var imageURLString: String
  var imageHDURLString: String

  var imageURL: URL? {
    return URL(string: imageURLString)
  }

  var imageHDURL: URL? {
    return URL(string: imageHDURLString)
  }

  init(card: Card) {
    self.id = card.id
    self.name = card.name
    self.hp = card.hp
    self.imageURLString = card.imageURLString
    self.imageHDURLString = card.imageHDURLString
  }
}
