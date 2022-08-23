//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture

struct LoadedState: Equatable {

}

public enum LoadedAction: Equatable {

}

let loadedReducer = Reducer<LoadedState, LoadedAction, LoadAndNavigateEnvironment> { _, _, _ in
  return .none
}
