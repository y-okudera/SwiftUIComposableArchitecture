//
//  CardsCore.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/10.
//

import ComposableArchitecture

enum CardsCore {

    // MARK: - State

    struct State: Equatable {
        var cards = IdentifiedArrayOf<CardDetailCore.State>()
        var favorites = [Card]()

        var currentPage = 1
        let pageSize = 100
        var isLoading = false
        var isLoadingPage = false

        // MARK: Helper

        func isFavorite(with card: Card) -> Bool {
            return favorites.contains(where: { $0.id == card.id })
        }
        func isLastItem(_ item: UUID) -> Bool {
            let itemIndex = cards.firstIndex(where: { $0.id == item })
            return itemIndex == cards.endIndex - 1
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case retrieve
        case retrieveNextPageIfNeeded(currentItem: UUID)
        case cardsResponse(Result<Cards, ApiError>)

        case retrieveFavorites
        case favoritesResponse(Result<[Card], Never>)

        case loadingActive(Bool)
        case loadingPageActive(Bool)

        case card(id: UUID, action: CardDetailCore.Action)

        case onAppear
        case onDisappear
    }

    // MARK: - Environment

    struct Environment {
        var apiClient: ApiClient
        var localDatabaseClient: LocalDatabaseClient
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var uuid: () -> UUID
    }

    // MARK: - Reducer

    static let reducer =
        Reducer<State, Action, Environment>.combine(
            CardDetailCore.reducer.forEach(
                state: \.cards,
                action: /Action.card(id:action:),
                environment: { environment in
                    .init(
                        localDatabaseClient: .live,
                        mainQueue: environment.mainQueue
                    )
                }
            ),
            .init { state, action, environment in

                struct CardsCancelId: Hashable {}

                switch action {
                case .onAppear:
                    guard state.cards.isEmpty else { return .init(value: .retrieveFavorites) }
                    return .init(value: .retrieve)

                case .retrieve:
                    state.cards = []
                    state.currentPage = 1
                    return .concatenate(
                        .init(value: .loadingActive(true)),
                        environment.apiClient
                            .cardsPage(state.currentPage, state.pageSize)
                            .receive(on: environment.mainQueue)
                            .catchToEffect()
                            .map(Action.cardsResponse)
                            .cancellable(id: CardsCancelId()),
                        .init(value: .retrieveFavorites)
                    )

                case .retrieveNextPageIfNeeded(currentItem: let item):
                    guard state.isLastItem(item),
                          !state.isLoadingPage else {
                        return .none
                    }

                    state.currentPage += 1
                    return .concatenate(
                        .init(value: .loadingPageActive(true)),
                        environment.apiClient
                            .cardsPage(state.currentPage, state.pageSize)
                            .receive(on: environment.mainQueue)
                            .catchToEffect()
                            .map(Action.cardsResponse)
                            .cancellable(id: CardsCancelId())
                    )

                case .retrieveFavorites:
                    return environment.localDatabaseClient
                        .fetchFavoriteCards()
                        .receive(on: environment.mainQueue)
                        .catchToEffect()
                        .map(Action.favoritesResponse)
                        .cancellable(id: CardsCancelId())

                case .cardsResponse(.success(let cards)):
                    let cardItems = IdentifiedArrayOf<CardDetailCore.State>(
                        uniqueElements: cards.cards.map {
                            CardDetailCore.State(
                                id: environment.uuid(),
                                card: $0
                            )
                        }
                    )
                    state.cards = cardItems
                    return .concatenate(
                        .init(value: .loadingActive(false)),
                        .init(value: .loadingPageActive(false))
                    )
                    
                case .cardsResponse(.failure(let error)):
                    return .concatenate(
                        .init(value: .loadingActive(false)),
                        .init(value: .loadingPageActive(false))
                    )

                case .favoritesResponse(.success(let favorites)):
                    state.favorites = favorites
                    return .none

                case .loadingActive(let isLoading):
                    state.isLoading = isLoading
                    return .none

                case .loadingPageActive(let isLoading):
                    state.isLoadingPage = isLoading
                    return .none

                case .card(id: _, action: .onDisappear):
                    return .init(value: .retrieveFavorites)

                case .card(id: _, action: _):
                    return .none

                case .onDisappear:
                    return .cancel(id: CardsCancelId())
                }
            }
        )

}
