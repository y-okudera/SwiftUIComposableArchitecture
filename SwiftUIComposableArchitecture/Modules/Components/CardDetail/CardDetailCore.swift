//
//  CardDetailCore.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture

// MARK: - State

struct CardDetailState: Equatable, Identifiable {
    let id: UUID
    var card: Card

    var isFavorite = false
    var favorites = [Card]()
}

// MARK: - Action

enum CardDetailAction: Equatable {
    case onAppear
    case onDisappear

    case toggleFavorite
    case favoritesResponse(Result<[Card], Never>)
    case toggleFavoriteResponse(Result<[Card], Never>)
}

// MARK: - Environment

struct CardDetailEnvironment {
    var localDatabaseClient: LocalDatabaseClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer

let cardDetailReducer =
    Reducer<CardDetailState, CardDetailAction, CardDetailEnvironment> { state, action, environment in

        struct CardDetailCancelId: Hashable {}

        switch action {
        case .onAppear:
            return environment.localDatabaseClient
                .fetchFavoriteCards()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(CardDetailAction.favoritesResponse)
                .cancellable(id: CardDetailCancelId())

        case .favoritesResponse(.success(let favorites)),
             .toggleFavoriteResponse(.success(let favorites)):
            state.favorites = favorites
            state.isFavorite = favorites.contains(where: { $0.id == state.card.id })
            return .none

        case .toggleFavorite:
            if state.isFavorite {
                return environment.localDatabaseClient
                    .deleteFavoriteCard(state.card)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(CardDetailAction.toggleFavoriteResponse)
                    .cancellable(id: CardDetailCancelId())
            } else {
                return environment.localDatabaseClient
                    .insertFavoriteCard(state.card)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(CardDetailAction.toggleFavoriteResponse)
                    .cancellable(id: CardDetailCancelId())
            }

        case .onDisappear:
            return .cancel(id: CardDetailCancelId())
        }
    }
