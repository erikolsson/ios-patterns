//
//  AppCore.swift
//  Patterns
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture
import LoadAndNavigate
import NavigateAndLoad
import Downloads
import Form
import Common

public struct AppState: Equatable {
  var loadAndNavigate = LoadAndNavigateState()
  var navigateAndLoad = NavigateAndLoadState()
  var cells = DownloadsState()
  var form = FormState()

  public init() {}
}

public enum AppAction: Equatable {
  case loadAndNavigate(LoadAndNavigateAction)
  case navigateAndLoad(NavigateAndLoadAction)
  case downloads(DownloadsAction)
  case form(FormAction)
}

public struct AppEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  public init(mainQueue: AnySchedulerOf<DispatchQueue> = .main) {
    self.mainQueue = mainQueue
  }
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>
  .combine(
    loadAndNavigateReducer.pullback(state: \.loadAndNavigate,
                                    action: /AppAction.loadAndNavigate,
                                    environment: { env in LoadAndNavigateEnvironment(mainQueue: env.mainQueue) }),
    navigateAndLoadReducer.pullback(state: \.navigateAndLoad,
                                    action: /AppAction.navigateAndLoad,
                                    environment: { env in NavigateAndLoadEnvironment(mainQueue: env.mainQueue) }),
    cellsReducer.pullback(state: \.cells,
                          action: /AppAction.downloads,
                          environment: { env in DownloadsEnvironment(mainQueue: env.mainQueue) }),
    formReducer.pullback(state: \.form,
                         action: /AppAction.form,
                         environment: { env in FormEnvironment(mainQueue: env.mainQueue)})
  )

enum DisplayItem: Hashable, CaseIterable {
  case loadAndNavigate
  case navigateAndLoad
  case cellStates
  case form

  var title: String {
    switch self {
    case .loadAndNavigate:
      return "Load and navigate"

    case .navigateAndLoad:
      return "Navigate and load"

    case .cellStates:
      return "Cell States Example"

    case .form:
      return "Form example"
    }
  }
}

extension AppState {

  var displaySections: [SectionWrapper<Int, DisplayItem>] {
    return [
      SectionWrapper(sectionIdentifier: 0, items: DisplayItem.allCases)
    ]
  }
}
