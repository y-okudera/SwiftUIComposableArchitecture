//
//  AppDelegateCore.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Client
import ComposableArchitecture
import SwiftUI

public enum AppDelegateCore {
  // MARK: - State

  public struct State: Equatable {
    public init() {}
  }

  // MARK: - Action

  public enum Action: Equatable {
    case didFinishLaunching
  }

  // MARK: - Environment

  public struct Environment {
    var localDatabaseClient: LocalDatabaseClient
  }

  // MARK: - Reducer

  public static let reducer =
    Reducer<State, Action, Environment> { _, action, _ in
      switch action {
      case .didFinishLaunching:
        print(".didFinishLaunching")
        return .none
      }
    }
}
