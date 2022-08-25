//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-25.
//

import UIKit
import SwiftUI
import ComposableArchitecture

public class LoadAndNavigateSwiftUIViewController: UIHostingController<LoadAndNavigateView> {

  public init(store: Store<LoadAndNavigate.State, LoadAndNavigate.Action>) {
    super.init(rootView: LoadAndNavigateView(store: store))
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
}

extension LoadAndNavigate.State {
  var navigationActive: Bool { loaded != nil }
}

public struct LoadAndNavigateView: View {

  let store: Store<LoadAndNavigate.State, LoadAndNavigate.Action>
  
  public var body: some View {
    WithViewStore(store) { viewStore in

      VStack {
        Button("Load") {
          viewStore.send(.buttonPressed)
        }

        if viewStore.isLoading {
          ProgressView("Loading...")
        }
      }

      NavigationLink(
        destination: IfLetStore(store.scope(state: \.loaded,
                                            action: LoadAndNavigate.Action.loaded)) { store in
                                              LoadedView(store: store)
                                            },
        isActive: viewStore.binding(get: \.navigationActive,
                                    send: LoadAndNavigate.Action.didCloseLoaded)) {}
    }

  }
}

struct LoadedView: View {
  let store: Store<Loaded.State, Loaded.Action>
  var body: some View {
    Text("Loaded!")
  }
}
