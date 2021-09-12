//
//  ApiLive.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/12.
//

import Combine
import ComposableArchitecture

// MARK: - Live

extension ApiClient {
    static let live = Self(
        cardsPage: { number, size in
            let route = ApiRoute.cardsPage(number: number, size: size)
            let request = ApiRouter.request(for: route)
            return requestPublisher(request)
                .apiDecode(as: Cards.self)
                .eraseToEffect()
        }
    )

    private static func requestPublisher(_ request: URLRequest) -> AnyPublisher<Data, ApiError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .mapError { .network(error: $0) }
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
