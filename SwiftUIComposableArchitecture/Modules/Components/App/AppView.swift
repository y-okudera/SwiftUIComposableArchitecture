//
//  AppView.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            TabView(
                selection: viewStore.binding(
                    get: { $0.selectedTab },
                    send: AppAction.selectedTabChange
                ),
                content: {
                    Group {
                        CardsView(store: cardsStore)
                            .tabItem {
                                Image(systemName: "greetingcard")
                                Text(LocalizedStringKey("Cards"))
                            }
                            .tag(AppState.Tab.cards)
                        FavoritesView(store: favoritesStore)
                            .tabItem {
                                Image(systemName: "star")
                                Text(LocalizedStringKey("Favorites"))
                            }
                            .tag(AppState.Tab.favorites)
                    }
                }
            )
        }
    }
}

// MARK: - Store inits

extension AppView {
    private var cardsStore: Store<CardsState, CardsAction> {
        return store.scope(
            state: { $0.cardsState },
            action: AppAction.cards
        )
    }

    private var favoritesStore: Store<FavoritesState, FavoritesAction> {
        return store.scope(
            state: { $0.favoritesState },
            action: AppAction.favorites
        )
    }
}

// MARK: - Previews

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: .init(
                initialState: AppState(),
                reducer: appReducer,
                environment: .init(
                    localDatabaseClient: .mockPreview(),
                    apiClient: .mockPreview(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    uuid: UUID.init
                )
            )
        )
    }
}
