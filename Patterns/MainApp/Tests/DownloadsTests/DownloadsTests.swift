//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-26.
//

import XCTest
@testable import Downloads
import ComposableArchitecture

@MainActor
final class DownloadsTests: XCTestCase {

  func testButtonPressed() async throws {
    let sut = TestStore(initialState: Downloads.State(),
                    reducer: Downloads())
    sut.dependencies.uuid = .incrementing

    await sut.send(.viewDidLoad) {
      let generateUUID = UUIDGenerator.incrementing
      for _ in 0..<50 {
        $0.addDownload(id: generateUUID())
      }
    }
  }

}
