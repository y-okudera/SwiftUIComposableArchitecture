//
//  ApiDecode.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/12.
//

import Combine
import ComposableArchitecture
import Models

extension AnyPublisher where Output == Data, Failure == ApiError {
  func apiDecode<Response: Decodable>(as type: Response.Type, file: StaticString = #file, line: UInt = #line) -> Effect<Response, ApiError> {
    flatMap { data -> AnyPublisher<Response, ApiError> in
      // Decode Response
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return Just(data)
        .tryMap { try decoder.decode(Response.self, from: $0) }
        .mapError { .decoding(error: $0) }
        .eraseToAnyPublisher()
    }
    .eraseToEffect()
  }
}
