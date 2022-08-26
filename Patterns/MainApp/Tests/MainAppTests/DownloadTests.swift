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
final class DownloadTests: XCTestCase {

  func testButtonPressed() async throws {
    let sut = TestStore(initialState: Download.State(id: UUID(), title: "1"),
                    reducer: Download())
    sut.dependencies.mainQueue = .immediate

    await sut.send(.startDownload) {
      $0.downloadStatus = .downloading(0)
    }

    await sut.receive(.setDownloadStatus(.downloading(0)))
    await sut.receive(.setDownloadStatus(.downloading(0.5))) {
      $0.downloadStatus = .downloading(0.5)
    }

    await sut.receive(.setDownloadStatus(.downloading(1))) {
      $0.downloadStatus = .downloading(1)
    }
    await sut.receive(.setDownloadStatus(.finished)) {
      $0.downloadStatus = .finished
    }

  }

  func testFailingDownload() async throws {
    let sut = TestStore(initialState: Download.State(id: UUID(), title: "1"),
                    reducer: Download())
    sut.dependencies.mainQueue = .immediate
    sut.dependencies.simulatedDownload = .failing

    await sut.send(.startDownload) {
      $0.downloadStatus = .downloading(0)
    }

    await sut.receive(.setDownloadStatus(.failed)) {
      $0.downloadStatus = .failed
    }

  }

}
