//
//  Card.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/10.
//

import Foundation

struct Card: Decodable, Equatable, Identifiable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case hp
        case imageURLString = "imageUrl"
        case imageHDURLString = "imageUrlHiRes"
    }

    init(id: String,
         name: String,
         hp: String? = nil,
         imageURLString: String,
         imageHDURLString: String) {
        self.id = id
        self.name = name
        self.hp = hp
        self.imageURLString = imageURLString
        self.imageHDURLString = imageHDURLString
    }

    init(with favorite: FavoriteCard) {
        self.init(
            id: favorite.id,
            name: favorite.name,
            hp: favorite.hp,
            imageURLString: favorite.imageURLString,
            imageHDURLString: favorite.imageHDURLString
        )
    }
}

// MARK: Mock

extension Card {
    static var mock1: Card {
        Card(
            id: "xy7-4",
            name: "Bellossom",
            hp: "120",
            imageURLString: "https://images.pokemontcg.io/xy7/4.png",
            imageHDURLString: "https://images.pokemontcg.io/xy7/4_hires.png"
        )
    }

    static var mock2: Card {
        Card(
            id: "ex16-1",
            name: "Aggron",
            hp: "110",
            imageURLString: "https://images.pokemontcg.io/ex16/1.png",
            imageHDURLString: "https://images.pokemontcg.io/ex16/1_hires.png"
        )
    }
}
