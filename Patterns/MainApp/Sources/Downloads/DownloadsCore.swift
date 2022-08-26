//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture
import Common

public struct Downloads: ReducerProtocol {

  public struct State: Equatable {
    var downloads = IdentifiedArrayOf<Download.State>()
    public init() {}

    mutating func addDownload(id: UUID) {
      let index = downloads.count + 1
      downloads.append(Download.State(id: id, title: "\(index)"))
    }
  }

  public enum Action: Equatable {
    case viewDidLoad
    case cell(id: Download.State.ID, action: Download.Action)
  }

  @Dependency(\.uuid) var generateUUID
  public init() {}

  public var body: Reduce<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewDidLoad:
        if state.downloads.isEmpty {
          for _ in 0..<50 {
            state.addDownload(id: generateUUID())
          }
        }
        return .none

      case .cell:
        return .none
      }
    }
    .forEach(\.downloads,
              action: /Downloads.Action.cell(id:action:)) {
      Download()
    }
  }

}

enum DisplayItem: Hashable {
  case download(id: Download.State.ID)
}

extension Downloads.State {
  var displaySections: [SectionWrapper<Int, DisplayItem>] {
    return [
      SectionWrapper(sectionIdentifier: 0,
                     items: downloads.ids.elements.map(DisplayItem.download(id:)))
    ]
  }
}
