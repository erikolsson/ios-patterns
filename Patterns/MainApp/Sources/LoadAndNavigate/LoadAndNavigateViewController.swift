//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import Common
import Cartography
import ComposableArchitecture
import Combine

public class LoadAndNavigateViewController: StoreViewController<LoadAndNavigate.State, LoadAndNavigate.Action> {

  lazy var button = UIButton()

  let activityIndicatorView = UIActivityIndicatorView(style: .medium)

  public override func configureSubviews() {
    title = "Load and Navigate"
    view.backgroundColor = UIColor.systemBackground

    view.addSubview(button)
    view.addSubview(activityIndicatorView)
    activityIndicatorView.hidesWhenStopped = true

    button.setTitle("Load", for: .normal)
    button.setTitleColor(.red, for: .normal)
    constrain(view, button, activityIndicatorView) { view, button, activityIndicatorView in
      button.centerX == view.centerX
      button.top == view.top + 200
      activityIndicatorView.center == view.center
    }

  }

  public override func configureStateObservation() {
    viewStore.bind(\.isLoading, to: \._isAnimating, on: activityIndicatorView)
      .store(in: &cancellables)

    viewStore.receiveEvents(button, action: .buttonPressed)
      .store(in: &cancellables)

    pushViewController(store: store.scope(state: \.loaded,
                                          action: LoadAndNavigate.Action.loaded),
                       type: LoadedViewController.self,
                       dismissAction: .didCloseLoaded)
  }

}
