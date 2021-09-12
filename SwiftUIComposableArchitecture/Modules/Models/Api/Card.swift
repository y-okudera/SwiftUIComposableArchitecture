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
            id: "xy7-10",
            name: "Vespiquen",
            hp: "90",
            imageURLString: "https://images.pokemontcg.io/xy7/10.png",
            imageHDURLString: "https://images.pokemontcg.io/xy7/10_hires.png"
        )
    }

    static var mock2: Card {
        Card(
            id: "dp6-90",
            name: "Cubone",
            hp: "60",
            imageURLString: "https://images.pokemontcg.io/dp6/90.png",
            imageHDURLString: "https://images.pokemontcg.io/dp6/90_hires.png"
        )
    }

    static var mock3: Card {
        Card(
            id: "swsh4-175",
            name: "Drapion V",
            hp: "210",
            imageURLString: "https://images.pokemontcg.io/swsh4/175.png",
            imageHDURLString: "https://images.pokemontcg.io/swsh4/175_hires.png"
        )
    }

    static var mock4: Card {
        Card(
            id: "ex14-85",
            name: "Windstorm",
            hp: "None",
            imageURLString: "https://images.pokemontcg.io/ex14/85.png",
            imageHDURLString: "https://images.pokemontcg.io/ex14/85_hires.png"
        )
    }

    static var mock5: Card {
        Card(
            id: "pl2-103",
            name: "Alakazam 4",
            hp: "100",
            imageURLString: "https://images.pokemontcg.io/pl2/103.png",
            imageHDURLString: "https://images.pokemontcg.io/pl2/103_hires.png"
        )
    }

    static var mock6: Card {
        Card(
            id: "ex8-100",
            name: "Hariyama ex",
            hp: "110",
            imageURLString: "https://images.pokemontcg.io/ex8/100.png",
            imageHDURLString: "https://images.pokemontcg.io/ex8/100_hires.png"
        )
    }

    static var mock7: Card {
        Card(
            id: "xy7-4",
            name: "Bellossom",
            hp: "120",
            imageURLString: "https://images.pokemontcg.io/xy7/4.png",
            imageHDURLString: "https://images.pokemontcg.io/xy7/4_hires.png"
        )
    }

    static var mock8: Card {
        Card(
            id: "ex16-1",
            name: "Aggron",
            hp: "110",
            imageURLString: "https://images.pokemontcg.io/ex16/1.png",
            imageHDURLString: "https://images.pokemontcg.io/ex16/1_hires.png"
        )
    }

    static var mock9: Card {
        Card(
            id: "xy11-41",
            name: "Joltik",
            hp: "30",
            imageURLString: "https://images.pokemontcg.io/xy11/41.png",
            imageHDURLString: "https://images.pokemontcg.io/xy11/41_hires.png"
        )
    }

    static var mock10: Card {
        Card(
            id: "pl2-104",
            name: "Floatzel GL",
            hp: "100",
            imageURLString: "https://images.pokemontcg.io/pl2/104.png",
            imageHDURLString: "https://images.pokemontcg.io/pl2/104_hires.png"
        )
    }
}
