//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-19.
//

import UIKit
import Combine
import ComposableArchitecture

public struct TwoWayBinding<Value> {
  public let publisher: AnyPublisher<BindableState<Value>, Never>
  public let send: (Value) -> Void
}

public extension ViewStore where Action: BindableAction, Action.State == State {
  func twoWayBinding<LocalState>(
    keyPath: WritableKeyPath<State, BindableState<LocalState>>
  ) -> TwoWayBinding<LocalState>
  where LocalState: Equatable {
    return TwoWayBinding(
      publisher: self.publisher.map(keyPath).eraseToAnyPublisher(),
      send: { self.send(Action.binding(.set(keyPath, $0))) }
    )
  }
}

public extension TwoWayBinding {
  func attach<Control: UIControl>(to keyPath: ReferenceWritableKeyPath<Control, Value>,
                                  on: Control, events: UIControl.Event = .allEditingEvents) -> AnyCancellable {
    let getter = publisher
      .map(\.wrappedValue)
      .assign(to: keyPath, on: on)

    let setter = Publishers.ControlProperty(control: on, events: events, keyPath: keyPath)
      .sink(receiveValue: self.send)

    return AnyCancellable {
      getter.cancel()
      setter.cancel()
    }
  }

  func attach<Control: UIControl>(to keyPath: ReferenceWritableKeyPath<Control, Value?>,
                                  on: Control, events: UIControl.Event = .allEditingEvents) -> AnyCancellable {
    let getter = publisher
      .map(\.wrappedValue)
      .map(Optional.some)
      .assign(to: keyPath, on: on)

    let setter = Publishers.ControlProperty(control: on, events: events, keyPath: keyPath)
      .compactMap { $0 }
      .sink(receiveValue: self.send)

    return AnyCancellable {
      getter.cancel()
      setter.cancel()
    }
  }
}
