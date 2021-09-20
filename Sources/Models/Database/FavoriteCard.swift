//
//  FavoriteCard.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Foundation
import RealmSwift

public final class FavoriteCard: Object {
  @objc public var id: String = "0"
  @objc public var name: String = ""
  @objc public var hp: String? = "0"
  @objc public var imageURLString: String = ""
  @objc public var imageHDURLString: String = ""

  override public class func primaryKey() -> String? {
    return "id"
  }

  var imageURL: URL? {
    return URL(string: imageURLString)
  }

  var imageHDURL: URL? {
    return URL(string: imageHDURLString)
  }

  public convenience init(card: Card) {
    self.init()
    self.id = card.id
    self.name = card.name
    self.hp = card.hp
    self.imageURLString = card.imageURLString
    self.imageHDURLString = card.imageHDURLString
  }
}
