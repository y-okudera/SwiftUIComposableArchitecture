//
//  AppDelegateState.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import ComposableArchitecture
import SwiftUI

// MARK: - State

struct AppDelegateState: Equatable {}

// MARK: - Action

enum AppDelegateAction: Equatable {
    case didFinishLaunching
}

// MARK: - Environment

struct AppDelegateEnvironment {
    var localDatabaseClient: LocalDatabaseClient
}

// MARK: - Reducer

let appDelegateReducer = Reducer<AppDelegateState, AppDelegateAction, AppDelegateEnvironment> { _, action, environment in
    switch action {
    case .didFinishLaunching:
        _ = environment.localDatabaseClient
            .migrate()
        return .none
    }
}
