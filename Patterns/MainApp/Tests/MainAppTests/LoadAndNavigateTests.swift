//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-25.
//

import XCTest
@testable import LoadAndNavigate
import ComposableArchitecture

@MainActor
final class LoadAndNavigateTests: XCTestCase {

  func testButtonPressed() async throws {
    let sut = TestStore(initialState: LoadAndNavigate.State(), reducer: LoadAndNavigate())
    sut.dependencies.mainQueue = .immediate
    await sut.send(.buttonPressed) {
      $0.isLoading = true
    }
    await sut.receive(.loadingCompleted) {
      $0.isLoading = false
      $0.loaded = Loaded.State()
    }
  }

  func testDidCloseLoaded() async {
    var initialState = LoadAndNavigate.State()
    initialState.loaded = .init()
    let sut = TestStore(initialState: initialState, reducer: LoadAndNavigate())
    sut.dependencies.mainQueue = .immediate
    await sut.send(.didCloseLoaded) {
      $0.loaded = nil
    }
  }

}
