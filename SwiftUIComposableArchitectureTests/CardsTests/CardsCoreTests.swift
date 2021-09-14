//
//  CardsCoreTests.swift
//  SwiftUIComposableArchitectureTests
//
//  Created by Yuki Okudera on 2021/09/12.
//

import ComposableArchitecture
@testable import SwiftUIComposableArchitecture
import XCTest

final class CardsCoreTests: XCTestCase {
  func testOnAppear() {
    var pageNumber = 0
    var pageSize = 0
    var didRequestCardsPage = false
    var didFetchFavoriteCards = false

    var environment = CardsCore.Environment.failing
    environment.apiClient.cardsPage = { number, size in
      .fireAndForget {
        pageNumber = number
        pageSize = size
        didRequestCardsPage = true
      }
    }
    environment.localDatabaseClient.fetchFavoriteCards = {
      .fireAndForget {
        didFetchFavoriteCards = true
      }
    }
    environment.mainQueue = .immediate

    let store = TestStore(
      initialState: CardsCore.State(),
      reducer: CardsCore.reducer,
      environment: environment
    )

    // Send action

    store.send(.onAppear)

    // Receive action and update State if needed.

    store.receive(.retrieve)
    store.receive(.loadingActive(true)) {
      $0.isLoading = true
    }
    store.receive(.retrieveFavorites)

    XCTAssertNoDifference(pageNumber, 1)
    XCTAssertNoDifference(pageSize, 100)
    XCTAssertNoDifference(didRequestCardsPage, true)
    XCTAssertNoDifference(didFetchFavoriteCards, true)
  }
}

extension CardsCore.Environment {
  static let failing = Self(
    apiClient: .mock(),
    localDatabaseClient: .mock(),
    mainQueue: .failing(""),
    uuid: UUID.init
  )
}
