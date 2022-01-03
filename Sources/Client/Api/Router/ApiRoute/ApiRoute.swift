//
//  ApiRoute.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Foundation
import Models

enum ApiRoute {
  // MARK: - Cases

  case cardsPage(number: Int, size: Int)

  // MARK: - Variables

  var path: String {
    switch self {
    case .cardsPage:
      return "cards"
    }
  }
  var queryItems: [URLQueryItem]? {
    switch self {
    case .cardsPage(let number, let size):
      return [
        URLQueryItem(name: "page", value: "\(number)"),
        URLQueryItem(name: "pageSize", value: "\(size)"),
      ]
    }
  }
  var httpMethod: String {
    switch self {
    case .cardsPage:
      return "GET"
    }
  }
  var responseType: Decodable.Type {
    switch self {
    case .cardsPage:
      return Cards.self
    }
  }

  var baseUrl: URL? {
    switch self {
    case .cardsPage:
      return pokemonTCGBaseUrl
    }
  }

  var url: URL {
    switch self {
    case .cardsPage:
      return pokemonTCGUrl
    }
  }
}

// MARK: - Specific Urls

extension ApiRoute {
  private var pokemonTCGBaseUrl: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.pokemontcg.io"
    return components.url
  }

  var pokemonTCGUrl: URL {
    let apiVersion = "v1"
    guard let url = URL(string: "/\(apiVersion)/\(path)", relativeTo: baseUrl),
      var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    else {
      fatalError("url or components nil")
    }

    components.queryItems = queryItems
    return components.url!
  }
}
