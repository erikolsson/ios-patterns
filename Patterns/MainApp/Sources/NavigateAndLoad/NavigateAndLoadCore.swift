//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture

public struct NavigateAndLoadState: Equatable {
  public init() {}
}

public enum NavigateAndLoadAction: Equatable {

}

public struct NavigateAndLoadEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  public init(mainQueue: AnySchedulerOf<DispatchQueue> = .main) {
    self.mainQueue = mainQueue
  }
}

public let navigateAndLoadReducer = Reducer<NavigateAndLoadState, NavigateAndLoadAction, NavigateAndLoadEnvironment> { state, action, env in
  return .none
}
