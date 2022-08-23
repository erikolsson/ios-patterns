//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture

public struct LoadAndNavigateState: Equatable {
  var isLoading = false
  var loaded: LoadedState?
  public init() {}
}

public enum LoadAndNavigateAction: Equatable {
  case buttonPressed
  case loadingCompleted
  case didCloseLoaded
  case loaded(LoadedAction)
}

public struct LoadAndNavigateEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  public init(mainQueue: AnySchedulerOf<DispatchQueue> = .main) {
    self.mainQueue = mainQueue
  }
}

let loadAndNavigateViewReducer = Reducer<LoadAndNavigateState, LoadAndNavigateAction, LoadAndNavigateEnvironment> { state, action , env in

  switch action {
  case .buttonPressed:
    state.isLoading = true
    return .task {
      try await env.mainQueue.sleep(for: 1)
      return .loadingCompleted
    }

  case .loadingCompleted:
    state.isLoading = false
    state.loaded = LoadedState()
    return .none

  case .didCloseLoaded:
    state.loaded = nil
    return .none

  case .loaded:
    return .none
  }

}

public let loadAndNavigateReducer = Reducer<LoadAndNavigateState, LoadAndNavigateAction, LoadAndNavigateEnvironment>
  .combine(
    loadedReducer.optional().pullback(state: \.loaded,
                                      action: /LoadAndNavigateAction.loaded,
                                      environment: {$0}),
    loadAndNavigateViewReducer
  )
