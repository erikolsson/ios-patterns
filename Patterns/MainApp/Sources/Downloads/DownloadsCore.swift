//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture
import Common

public struct DownloadsState: Equatable {
  var downloads = IdentifiedArrayOf<DownloadState>()
  public init() {}

  mutating func addDownload() {
    let index = downloads.count + 1
    downloads.append(DownloadState(title: "\(index)"))
  }
}

public enum DownloadsAction: Equatable {
  case viewDidLoad
  case cell(id: DownloadState.ID, action: CellAction)
}

public struct DownloadsEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  public init(mainQueue: AnySchedulerOf<DispatchQueue> = .main) {
    self.mainQueue = mainQueue
  }
}

let cellsViewReducer = Reducer<DownloadsState, DownloadsAction, DownloadsEnvironment> { state, action, env in
  switch action {
  case .viewDidLoad:
    if state.downloads.isEmpty {
      for i in 0..<50 {
        state.addDownload()
      }
    }
    return .none

  case .cell:
    return .none
  }
}

public let cellsReducer = Reducer<DownloadsState, DownloadsAction, DownloadsEnvironment>
  .combine(
    cellReducer.forEach(state: \.downloads,
                        action: /DownloadsAction.cell(id:action:),
                        environment: {$0}),
    cellsViewReducer
  )

enum DisplayItem: Hashable {
  case download(id: DownloadState.ID)
}

extension DownloadsState {
  var displaySections: [SectionWrapper<Int, DisplayItem>] {
    return [
      SectionWrapper(sectionIdentifier: 0, items: downloads.ids.elements.map(DisplayItem.download(id:)))
    ]
  }
}
