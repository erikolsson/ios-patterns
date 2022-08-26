//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture

public struct Download: ReducerProtocol {

  public struct State: Equatable, Identifiable {
    public let id: UUID
    let title: String
    var downloadStatus: SimulatedDownload.Status = .idle
  }

  public enum Action: Equatable {
    case startDownload
    case setDownloadStatus(SimulatedDownload.Status)
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.simulatedDownload) var simulatedDownload

  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
    case .startDownload:

      switch state.downloadStatus {
      case .finished:
        return .none
      case .downloading:
        state.downloadStatus = .idle
        return .cancel(id: state.id)

      case .failed, .idle:
        state.downloadStatus = .downloading(0)
        return simulatedDownload.download(mainQueue)
          .cancellable(id: state.id)
          .map(Action.setDownloadStatus)
          .receive(on: mainQueue)
          .eraseToEffect()
      }

    case let .setDownloadStatus(status):
      state.downloadStatus = status
      return .none
    }
  }

}
