//
//  FavoritesCore.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture

// MARK: - State

struct FavoritesState: Equatable {
    var cards = IdentifiedArrayOf<CardDetailState>()
}

// MARK: - Action

enum FavoritesAction: Equatable {
    case retrieveFavorites
    case favoritesResponse(Result<[Card], Never>)

    case card(id: UUID, action: CardDetailAction)

    case onAppear
    case onDisappear
}

// MARK: - Environment

struct FavoritesEnvironment {
    var localDatabaseClient: LocalDatabaseClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

// MARK: - Reducer

let favoritesReducer =
    Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment>.combine(
        cardDetailReducer.forEach(
            state: \.cards,
            action: /FavoritesAction.card(id:action:),
            environment: { environment in
                .init(
                    localDatabaseClient: environment.localDatabaseClient,
                    mainQueue: environment.mainQueue
                )
            }
        ),
        .init { state, action, environment in

            struct FavoritesCancelId: Hashable {}

            switch action {
            case .onAppear:
                guard state.cards.isEmpty else { return .none }
                return .init(value: .retrieveFavorites)

            case .retrieveFavorites:
                return environment.localDatabaseClient
                    .fetchFavoriteCards()
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(FavoritesAction.favoritesResponse)
                    .cancellable(id: FavoritesCancelId())

            case .favoritesResponse(.success(let favorites)):
                state.cards = .init(
                    uniqueElements: favorites.map {
                        CardDetailState(
                            id: environment.uuid(),
                            card: $0
                        )
                    }
                )
                return .none
                
            case .card(id: _, action: .onDisappear):
                return .init(value: .retrieveFavorites)
                
            case .card(id: _, action: _):
                return .none
                
            case .onDisappear:
                return .cancel(id: FavoritesCancelId())
            }
        }
    )
