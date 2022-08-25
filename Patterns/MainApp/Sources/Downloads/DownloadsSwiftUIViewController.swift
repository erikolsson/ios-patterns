//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-25.
//

import UIKit
import SwiftUI
import ComposableArchitecture


public class DownloadsSwiftUIViewController: UIHostingController<DownloadsView> {

  public init(store: Store<Downloads.State, Downloads.Action>) {
    super.init(rootView: DownloadsView(store: store))
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
}

public struct DownloadsView: View {

  let store: Store<Downloads.State, Downloads.Action>
  public var body: some View {
    WithViewStore(store) { viewStore in
      List {
        ForEachStore(store.scope(state: \.downloads,
                                 action: Downloads.Action.cell(id:action:))) { downloadStore in
          DownloadView(store: downloadStore)
        }
      }
      .listStyle(.plain)
      .task {
        viewStore.send(.viewDidLoad)
      }
    }
  }
}

struct DownloadView: View {

  let store: Store<Download.State, Download.Action>
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack {
        Text(viewStore.title)
        Spacer()
        Button(viewStore.downloadButtonTitle) {
          viewStore.send(.startDownload)
        }
        .buttonStyle(.borderless)
      }
    }
  }
}
