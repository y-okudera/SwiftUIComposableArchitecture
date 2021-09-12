//
//  AppCore.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture

// MARK: - State

struct AppState: Equatable {
    var appDelegateState = AppDelegateState()
    var cardsState = CardsState()
    var favoritesState = FavoritesState()

    enum Tab {
        case cards
        case favorites
    }

    var selectedTab = Tab.cards
}

// MARK: - Action

enum AppAction {
    case appDelegate(AppDelegateAction)
    case cards(CardsAction)
    case favorites(FavoritesAction)

    case selectedTabChange(AppState.Tab)
}

// MARK: - Environment

struct AppEnvironment {
    var localDatabaseClient: LocalDatabaseClient
    var apiClient: ApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

// MARK: - Reducer

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    appDelegateReducer.pullback(
        state: \AppState.appDelegateState,
        action: /AppAction.appDelegate,
        environment: {
            AppDelegateEnvironment(
                localDatabaseClient: $0.localDatabaseClient
            )
        }
    ),
    cardsReducer.pullback(
        state: \AppState.cardsState,
        action: /AppAction.cards,
        environment: { environment in
            CardsEnvironment(
                apiClient: environment.apiClient,
                localDatabaseClient: environment.localDatabaseClient,
                mainQueue: environment.mainQueue,
                uuid: environment.uuid
            )
        }
    ),
    favoritesReducer.pullback(
        state: \AppState.favoritesState,
        action: /AppAction.favorites,
        environment: { environment in
            FavoritesEnvironment(
                localDatabaseClient: environment.localDatabaseClient,
                mainQueue: environment.mainQueue,
                uuid: environment.uuid
            )
        }
    ),
    .init { state, action, environment in

        switch action {
        case .appDelegate(_):
            return .none

        // Update favorites on Cards State
        case .cards(.card(id: _, action: .toggleFavoriteResponse(.success(let favorites)))):
            state.favoritesState.cards = .init(
                uniqueElements: favorites.map {
                    CardDetailState(
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
