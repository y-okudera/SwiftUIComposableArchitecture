//
//  CardsViewTests.swift
//  SwiftUIComposableArchitectureTests
//
//  Created by Yuki Okudera on 2021/09/12.
//

import ComposableArchitecture
import SnapshotTesting
@testable import SwiftUIComposableArchitecture
import XCTest

final class CardsViewTests: XCTestCase {
  override func setUp() {
//        isRecording = true
  }

  func testDefault() {
    SnapshotDevices.allCases.forEach {
      assertSnapshot(
        matching: CardsView(
          store: .init(
            initialState: .init(
              cards: [],
              favorites: [],
              currentPage: 1,
              isLoading: false,
              isLoadingPage: false
            ),
            reducer: .empty,
            environment: ()
          )
        ),
        as: .image(layout: $0.layout)
      )
    }
  }

  func testLoadingFirstTime() {
    SnapshotDevices.allCases.forEach {
      assertSnapshot(
        matching: CardsView(
          store: .init(
            initialState: .init(
              cards: [],
              favorites: [],
              currentPage: 1,
              isLoading: true,
              isLoadingPage: false
            ),
            reducer: .empty,
            environment: ()
          )
        ),
        as: .image(layout: $0.layout)
      )
    }
  }

  func testLoadingNextPage() {
    SnapshotDevices.allCases.forEach {
      assertSnapshot(
        matching: CardsView(
          store: .init(
            initialState: .init(
              cards: .mock(),
              favorites: [
                .mock1
              ],
              currentPage: 1,
              isLoading: false,
              isLoadingPage: true
            ),
            reducer: .empty,
            environment: ()
          )
        ),
        as: .image(layout: $0.layout)
      )
    }
  }

  func testLoaded() {
    SnapshotDevices.allCases.forEach {
      assertSnapshot(
        matching: CardsView(
          store: .init(
            initialState: .init(
              cards: .mock(),
              favorites: [
                .mock1
              ],
              currentPage: 1,
              isLoading: false,
              isLoadingPage: false
            ),
            reducer: .empty,
            environment: ()
          )
        ),
        as: .image(layout: $0.layout)
      )
    }
  }
}

extension IdentifiedArrayOf where Element == CardDetailCore.State {
  static func mock() -> IdentifiedArrayOf<Element> {
    return .init(
      uniqueElements: [
        Card.mock1,
        Card.mock2,
        Card.mock3,
        Card.mock4,
        Card.mock5,
        Card.mock6,
        Card.mock7,
        Card.mock8,
        Card.mock9,
        Card.mock10
      ].map {
        CardDetailCore.State(
          id: UUID(),
          card: $0
        )
      }
    )
  }
}
