//
//  FavoritesCore.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Client
import ComposableArchitecture
import Models

public enum FavoritesCore {
  // MARK: - State

  public struct State: Equatable {
    var cards: IdentifiedArrayOf<CardDetailCore.State> = .init()
  }

  // MARK: - Action

  public enum Action: Equatable {
    case retrieveFavorites
    case favoritesResponse(Result<[Card], Never>)

    case card(id: UUID, action: CardDetailCore.Action)

    case onAppear
    case onDisappear
  }

  // MARK: - Environment

  struct Environment {
    var localDatabaseClient: LocalDatabaseClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
  }

  // MARK: - Reducer

  static let reducer =
    Reducer<FavoritesCore.State, FavoritesCore.Action, FavoritesCore.Environment>.combine(
      CardDetailCore.reducer.forEach(
        state: \.cards,
        action: /FavoritesCore.Action.card(id:action:),
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
            .map(FavoritesCore.Action.favoritesResponse)
            .cancellable(id: FavoritesCancelId())

        case .favoritesResponse(.success(let favorites)):
          state.cards = .init(
            uniqueElements: favorites.map {
              CardDetailCore.State(
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
}
