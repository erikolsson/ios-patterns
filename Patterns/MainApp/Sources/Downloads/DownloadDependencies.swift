//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-26.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {

  public var simulatedDownload: SimulatedDownload {
    get { self[SimulatedDownloadKey.self] }
    set { self[SimulatedDownloadKey.self] = newValue }
  }

  enum SimulatedDownloadKey: DependencyKey {
    static let liveValue = SimulatedDownload.live
    static let testValue = SimulatedDownload.test
  }

}

public struct SimulatedDownload {
  static let live: SimulatedDownload = SimulatedDownload { queue in
    return .run { send in
      var progress: Double = 0
      while progress < 1.0 {
        progress = min(1.0, progress + 0.01)
        await send(.downloading(progress))
        try await queue.sleep(for: 0.1)
        if Float.random(in: 0..<1) > 0.95 {
          await send(.failed)
          return
        }
      }
      await send(.finished)
    }
  }

  static let test: SimulatedDownload = SimulatedDownload { _ in
    return .run { send in
      await send(.downloading(0))
      await send(.downloading(0.5))
      await send(.downloading(1))
      await send(.finished)
    }
  }

  static let failing: SimulatedDownload = SimulatedDownload { _ in
    return .run { send in
      await send(.failed)
    }
  }

  public enum Status: Equatable {
    case idle
    case failed
    case downloading(Double)
    case finished
  }

  var download: (AnySchedulerOf<DispatchQueue>) -> Effect<Status, Never>

}
