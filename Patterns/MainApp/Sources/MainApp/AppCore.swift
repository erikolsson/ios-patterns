//
//  AppCore.swift
//  Patterns
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture
import LoadAndNavigate
import Downloads
import Form
import Common

public struct App: ReducerProtocol {

  public struct State: Equatable {
    var loadAndNavigate = LoadAndNavigate.State()
    var downloads = Downloads.State()
    var form = Form.State()
    public init() {}
  }

  public enum Action: Equatable {
    case loadAndNavigate(LoadAndNavigate.Action)
    case downloads(Downloads.Action)
    case form(Form.Action)
  }

  @Dependency(\.mainQueue) var mainQueue

  public var body: Reduce<State, Action> {
    Scope(state: \.form, action: /Action.form) {
      Form()
    }

    Scope(state: \.loadAndNavigate, action: /Action.loadAndNavigate) {
      LoadAndNavigate()
    }

    Scope(state: \.downloads, action: /Action.downloads) {
      Downloads()
    }
  }

  public init() {}
}

enum DisplayItem: Hashable, CaseIterable {
  case loadAndNavigate
  case cellStates
  case form

  var title: String {
    switch self {
    case .loadAndNavigate:
      return "Load and navigate"

    case .cellStates:
      return "Cell States Example"

    case .form:
      return "Form example"
    }
  }
}

extension App.State {

  var displaySections: [SectionWrapper<Int, DisplayItem>] {
    return [
      SectionWrapper(sectionIdentifier: 0, items: DisplayItem.allCases)
    ]
  }
}
