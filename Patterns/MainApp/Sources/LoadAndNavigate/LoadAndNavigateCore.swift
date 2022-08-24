//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture

public struct LoadAndNavigate: ReducerProtocol {
  public struct State: Equatable {
    var isLoading = false
    var loaded: Loaded.State?
    public init() {}
  }

  public enum Action: Equatable {
    case buttonPressed
    case loadingCompleted
    case didCloseLoaded
    case loaded(Loaded.Action)
  }

  @Dependency(\.mainQueue) var mainQueue

  public var body: Reduce<State, Action> {
    Reduce { state, action in
      switch action {
      case .buttonPressed:
        state.isLoading = true
        return .task {
          try await mainQueue.sleep(for: 1)
          return .loadingCompleted
        }

      case .loadingCompleted:
        state.isLoading = false
        state.loaded = Loaded.State()
        return .none

      case .didCloseLoaded:
        state.loaded = nil
        return .none

      case .loaded:
        return .none
      }
    }
    .ifLet(\.loaded,
            action: /Action.loaded) {
      Loaded()
    }

  }

  public init() {}
}
