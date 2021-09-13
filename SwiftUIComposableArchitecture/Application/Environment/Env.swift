//
//  Env.swift
//  SwiftUIComposableArchitecture
//
//  Created by okudera on 2021/09/13.
//

import Foundation

struct Env: Decodable {
    let pokemonTCGApiUrl: String
    let pokemonTCGApiVersion: String

    enum CodingKeys: String, CodingKey {
        case pokemonTCGApiUrl = "PokemonTCGApiUrl"
        case pokemonTCGApiVersion = "PokemonTCGApiVersion"
    }
}
