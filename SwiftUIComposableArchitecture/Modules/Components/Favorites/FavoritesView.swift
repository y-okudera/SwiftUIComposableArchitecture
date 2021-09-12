//
//  FavoritesView.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture
import SwiftUI

struct FavoritesView: View {
    var store: Store<FavoritesState, FavoritesAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    itemsList(viewStore)
                        .padding()
                }
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarTitle(LocalizedStringKey("Cards"))
            }
            .onAppear { viewStore.send(.onAppear) }
            .onDisappear { viewStore.send(.onDisappear) }
        }
    }
}

// MARK: - Views

extension FavoritesView {
    @ViewBuilder
    private func itemsList(_ viewStore: ViewStore<FavoritesState, FavoritesAction>) -> some View {
        if #available(iOS 14.0, *) {
            let gridItem = GridItem(.flexible(minimum: 80, maximum: 180))
            LazyVGrid(
                columns: [gridItem, gridItem, gridItem],
                alignment: .center,
                spacing: 16,
                content: { cardsList(viewStore) }
            )
        } else {
            VStack {
                cardsList(viewStore)
            }
        }
    }

    @ViewBuilder
    private func cardsList(_ viewStore: ViewStore<FavoritesState, FavoritesAction>) -> some View {
        ForEachStore(
            store.scope(
                state: { $0.cards },
                action: FavoritesAction.card(id:action:)
            ),
            content: { cardStore in
                WithViewStore(cardStore) { cardViewStore in
                    NavigationLink(
                        destination: CardDetailView(store: cardStore),
                        label: {
                            CardItemView(
                                card: cardViewStore.state.card,
                                isFavorite: true
                            )
                        }
                    )
                }
            }
        )
    }
}

// MARK: - Previews

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["en", "ja_JP"], id: \.self) { id in
            FavoritesView(
                store: .init(
                    initialState: .init(
                        cards: .init(
                            uniqueElements: Cards.mock.cards.map {
                                CardDetailState(
                                    id: .init(),
                                    card: $0
                                )
                            }
                        )
                    ),
                    reducer: favoritesReducer,
                    environment: .init(
                        localDatabaseClient: .mockPreview(),
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        uuid: UUID.init
                    )
                )
            )
            .environment(\.locale, .init(identifier: id))
        }
    }
}
