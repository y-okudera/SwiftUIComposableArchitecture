//
//  CardsView.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/10.
//

import ComposableArchitecture
import SwiftUI

struct CardsView: View {
  let store: Store<CardsCore.State, CardsCore.Action>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        ScrollView {
          Group {
            if viewStore.isLoading {
              VStack {
                Spacer()
                LottieView(
                  asset: Asset.pikachu.name,
                  isAnimating: viewStore.binding(
                    get: { $0.isLoading },
                    send: CardsCore.Action.loadingActive
                  )
                )
                .frame(width: 120, height: 120, alignment: .center)
                Spacer()
              }
            } else {
              VStack {
                itemsList(viewStore)
                LottieView(
                  asset: Asset.pikachu.name,
                  isAnimating: viewStore.binding(
                    get: { $0.isLoadingPage },
                    send: CardsCore.Action.loadingPageActive
                  )
                )
                .frame(width: 120, height: 120, alignment: .center)
              }
            }
          }
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

extension CardsView {
  @ViewBuilder
  private func itemsList(_ viewStore: ViewStore<CardsCore.State, CardsCore.Action>) -> some View {
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
  private func cardsList(_ viewStore: ViewStore<CardsCore.State, CardsCore.Action>) -> some View {
    ForEachStore(
      store.scope(
        state: { $0.cards },
        action: CardsCore.Action.card(id:action:)
      ),
      content: { cardStore in
        WithViewStore(cardStore) { cardViewStore in
          NavigationLink(
            destination: CardDetailView(store: cardStore),
            label: {
              CardItemView(
                card: cardViewStore.state.card,
                isFavorite: viewStore.state.isFavorite(with: cardViewStore.state.card)
              )
              .onAppear {
                viewStore.send(.retrieveNextPageIfNeeded(currentItem: cardViewStore.state.id))
              }
            }
          )
        }
      }
    )
  }
}

// MARK: - Previews

struct CardsView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach(["en", "ja_JP"], id: \.self) { id in
      CardsView(
        store: .init(
          initialState: .init(
            cards: .init(
              uniqueElements: Cards.mock.cards.map {
                CardDetailCore.State(
                  id: .init(),
                  card: $0
                )
              }
            )
          ),
          reducer: CardsCore.reducer,
          environment: .init(
            apiClient: .mockPreview(),
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
