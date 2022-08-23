//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-23.
//

import UIKit
import Combine
import ComposableArchitecture

public extension ViewStore {

  func receiveEvents(_ control: UIControl, events: UIControl.Event = .touchUpInside, action: Action) -> AnyCancellable {
    Publishers.ControlProperty(control: control, events: events, keyPath: \.self)
      .dropFirst()
      .sink { [weak self] _ in
        self?.send(action)
      }
  }

}
