//
//  AppDelegateCore.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture
import SwiftUI

enum AppDelegateCore {
  // MARK: - State

  struct State: Equatable {}

  // MARK: - Action

  enum Action: Equatable {
    case didFinishLaunching
  }

  // MARK: - Environment

  struct Environment {
    var localDatabaseClient: LocalDatabaseClient
  }

  // MARK: - Reducer

  static let reducer =
    Reducer<State, Action, Environment> { _, action, environment in
      switch action {
      case .didFinishLaunching:
        _ = environment.localDatabaseClient
          .migrate()
        return .none
      }
    }
}
