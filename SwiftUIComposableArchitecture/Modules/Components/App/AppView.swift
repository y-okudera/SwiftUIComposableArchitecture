//
//  AppView.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
  let store: Store<AppCore.State, AppCore.Action>

  var body: some View {
    WithViewStore(store) { viewStore in
      TabView(
        selection: viewStore.binding(
          get: { $0.selectedTab },
          send: AppCore.Action.selectedTabChange
        ),
        content: {
          Group {
            CardsView(store: cardsStore)
              .tabItem {
                Image(systemName: "greetingcard")
                Text(LocalizedStringKey("Cards"))
              }
              .tag(AppCore.State.Tab.cards)
            FavoritesView(store: favoritesStore)
              .tabItem {
                Image(systemName: "star")
                Text(LocalizedStringKey("Favorites"))
              }
              .tag(AppCore.State.Tab.favorites)
          }
        }
      )
    }
  }
}

// MARK: - Store inits

extension AppView {
  private var cardsStore: Store<CardsCore.State, CardsCore.Action> {
    return store.scope(
      state: { $0.cardsState },
      action: AppCore.Action.cards
    )
  }

  private var favoritesStore: Store<FavoritesCore.State, FavoritesCore.Action> {
    return store.scope(
      state: { $0.favoritesState },
      action: AppCore.Action.favorites
    )
  }
}

// MARK: - Previews

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(
      store: .init(
        initialState: AppCore.State(),
        reducer: AppCore.reducer,
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
