//
//  AppCore.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture

enum AppCore {
  // MARK: - State

  struct State: Equatable {
    var appDelegateState = AppDelegateCore.State()
    var cardsState = CardsCore.State()
    var favoritesState = FavoritesCore.State()

    // swiftlint:disable nesting
    enum Tab {
      case cards
      case favorites
    }

    var selectedTab = Tab.cards
  }

  // MARK: - Action

  enum Action {
    case appDelegate(AppDelegateCore.Action)
    case cards(CardsCore.Action)
    case favorites(FavoritesCore.Action)

    case selectedTabChange(State.Tab)
  }

  // MARK: - Environment

  struct Environment {
    var localDatabaseClient: LocalDatabaseClient
    var apiClient: ApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
  }

  // MARK: - Reducer

  static let reducer: Reducer<State, Action, Environment> =
    .combine(
      AppDelegateCore.reducer.pullback(
        state: \State.appDelegateState,
        action: /Action.appDelegate,
        environment: {
          AppDelegateCore.Environment(
            localDatabaseClient: $0.localDatabaseClient
          )
        }
      ),
      CardsCore.reducer.pullback(
        state: \State.cardsState,
        action: /Action.cards,
        environment: { environment in
          CardsCore.Environment(
            apiClient: environment.apiClient,
            localDatabaseClient: environment.localDatabaseClient,
            mainQueue: environment.mainQueue,
            uuid: environment.uuid
          )
        }
      ),
      FavoritesCore.reducer.pullback(
        state: \State.favoritesState,
        action: /Action.favorites,
        environment: { environment in
          FavoritesCore.Environment(
            localDatabaseClient: environment.localDatabaseClient,
            mainQueue: environment.mainQueue,
            uuid: environment.uuid
          )
        }
      ),
      .init { state, action, environment in

        switch action {
        case .appDelegate:
          return .none

        // Update favorites on Cards State
        case .cards(.card(id: _, action: .toggleFavoriteResponse(.success(let favorites)))):
          state.favoritesState.cards = .init(
            uniqueElements: favorites.map {
              CardDetailCore.State(
                id: environment.uuid(),
                card: $0
              )
            }
          )
          return .none

        case .cards:
          return .none

        // Update favorites on Favorites State
        case .favorites(.card(id: _, action: .toggleFavoriteResponse(.success(let favorites)))):
          state.cardsState.favorites = favorites
          return .none

        case .favorites:
          return .none

        case .selectedTabChange(let selectedTab):
          state.selectedTab = selectedTab
          return .none
        }
      }
    )
}
