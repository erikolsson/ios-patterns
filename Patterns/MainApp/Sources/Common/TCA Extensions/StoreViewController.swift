//
//  StateStoreViewController.swift
//  Patterns
//
//  Created by Erik Olsson on 2022-08-18.
//

import Combine
import ComposableArchitecture
import UIKit

open class StoreViewController<State: Equatable, Action>: UIViewController {
  
  open var store: Store<State, Action>
  open var viewStore: ViewStore<State, Action>
  open var cancellables: Set<AnyCancellable> = []
  open var onDismiss: (() -> ())?
  
  public required init(store: Store<State, Action>) {
    self.store = store
    self.viewStore = ViewStore(store)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable) public required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    configureSubviews()
    configureStateObservation()
  }
  
  open func configureSubviews() {}
  open func configureStateObservation() {}
  
  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guard isBeingDismissed || isMovingFromParent || (parent?.isBeingDismissed ?? false) else { return }
    onDismiss?()
  }
  
  public func pushViewController<A, B, C: StoreViewController<A, B>>(store: Store<A?, B>,
                                                                     type: C.Type,
                                                                     dismissAction: Action,
                                                                     configure: ((C) -> ())? = nil) {
    store.ifLet { [weak self] store in
      let vc = type.init(store: store)
      vc.onDismiss = {
        self?.viewStore.send(dismissAction)
      }
      configure?(vc)
      self?.navigationController?.pushViewController(vc, animated: true)
    }
    .store(in: &cancellables)
  }
  
  public func presentViewController<A, B, C: StoreViewController<A, B>>(store: Store<A?, B>,
                                                                        type: C.Type,
                                                                        dismissAction: Action,
                                                                        presentationStyle: UIModalPresentationStyle = .automatic) {
    store.ifLet { [weak self] store in
      let vc = type.init(store: store)
      vc.onDismiss = {
        self?.viewStore.send(dismissAction)
      }
      vc.modalPresentationStyle = presentationStyle
      self?.present(vc, animated: true, completion: nil)
    }
    .store(in: &cancellables)
  }
  
  public func presentNavigationController<A, B, C: StoreViewController<A, B>>(store: Store<A?, B>,
                                                                              type: C.Type,
                                                                              dismissAction: Action,
                                                                              presentationStyle: UIModalPresentationStyle = .automatic) {
    store.ifLet { [weak self] store in
      let vc = type.init(store: store)
      vc.onDismiss = {
        self?.viewStore.send(dismissAction)
      }
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = presentationStyle
      self?.present(nav, animated: true, completion: nil)
    }
    .store(in: &cancellables)
  }
  
}
