//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import Common
import ComposableArchitecture
import Cartography

class DownloadCell: StoreCell<Download.State, Download.Action> {

  let label = UILabel()
  let downloadButton = UIButton()

  override func setupViews() {
    contentView.addSubview(label)
    contentView.addSubview(downloadButton)

    constrain(contentView, label, downloadButton) { contentView, label, downloadButton in
      label.leading == contentView.leading + 16
      label.top == contentView.top + 16
      label.bottom == contentView.bottom - 16

      downloadButton.trailing == contentView.trailing - 16
      downloadButton.centerY == contentView.centerY
    }

    label.font = .preferredFont(forTextStyle: .title2)
    downloadButton.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)
    downloadButton.setTitleColor(.systemPink, for: .normal)
  }

  override func configureStateObservation(on viewStore: ViewStore<Download.State, Download.Action>) {
    viewStore.bind(\.title, to: \.text, on: label)
      .store(in: &cancellables)

    viewStore.bind(\.downloadButtonTitle, to: \.normalTitle, on: downloadButton)
      .store(in: &cancellables)
  }

  @objc
  func downloadButtonPressed() {
    viewStore?.send(.startDownload)
  }

}

extension Download.State {
  
  var downloadButtonTitle: String {
    switch progress {
    case .idle:
      return "Download"
    case .failed:
      return "Retry"
    case let .downloading(progress):
      return "Downloading: \(Int(progress * 100))%"
    case .finished:
      return "Finished"
    }
  }
}
