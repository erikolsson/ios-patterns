//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture

public struct DownloadState: Equatable, Identifiable {
  public enum DownloadProgress: Equatable {
    case idle
    case failed
    case downloading(Double)
    case finished
  }

  public let id = UUID()
  let title: String
  var progress: DownloadProgress = .idle
}

public enum CellAction: Equatable {
  case startDownload
  case setProgress(DownloadState.DownloadProgress)
}

let cellReducer = Reducer<DownloadState, CellAction, DownloadsEnvironment> { state, action, env in
  switch action {
  case .startDownload:

    switch state.progress {
    case .finished:
      return .none
    case .downloading:
      state.progress = .idle
      return .cancel(id: state.id)

    case .failed, .idle:
      state.progress = .downloading(0)
      return downloadTask(queue: env.mainQueue,
                          cancellationID: state.id)
    }

  case let .setProgress(progress):
    state.progress = progress
    return .none
  }

}

func downloadTask(queue: AnySchedulerOf<DispatchQueue>,
                  cancellationID: AnyHashable) -> Effect<CellAction, Never> {
  return .run { send in
    var progress: Double = 0
    while progress < 1.0 {
      progress = min(1.0, progress + 0.01)
      await send(.setProgress(.downloading(progress)))
      try await queue.sleep(for: 0.1)
    }
    await send(.setProgress(.finished))
  }
  .cancellable(id: cancellationID)
  .throttle(id: cancellationID, for: 0.5, scheduler: queue, latest: true)
}
