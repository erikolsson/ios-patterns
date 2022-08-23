//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-19.
//

import UIKit
import Common
import Cartography
import SwiftUI
import Combine
import ComposableArchitecture

public class FormViewController: StoreViewController<FormState, FormAction> {

  let collectionView = UICollectionView(frame: .zero,
                                        collectionViewLayout: FormViewController.collectionViewLayout())
  lazy var dataSource = UICollectionViewDiffableDataSource<Int, DisplayItem>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
    guard let viewStore = self?.viewStore else {
      return collectionView.dequeue(type: ToggleCell.self,
                                    indexPath: indexPath)
    }
    switch itemIdentifier {
    case let .bool(title: title, keyPath: keyPath):
      let cell = collectionView.dequeue(type: ToggleCell.self, indexPath: indexPath)
      cell.configure(title: title, binding: viewStore.twoWayBinding(keyPath: keyPath))
      return cell
    case let .string(title: title, keyPath: keyPath):
      let cell = collectionView.dequeue(type: TextCell.self, indexPath: indexPath)
      cell.configure(title: title, binding: viewStore.twoWayBinding(keyPath: keyPath))
      return cell
    }
  }

  public override func configureSubviews() {
    title = "Input Form with Two-Way Bindings"
    view.backgroundColor = .systemBackground
    view.addSubview(collectionView)
    collectionView.registerCellClass(type: ToggleCell.self)
    collectionView.registerCellClass(type: TextCell.self)
    collectionView.allowsSelection = false
    constrain(view, collectionView) { $1.edges == $0.edges }
  }

  public override func configureStateObservation() {
    viewStore.bind(sections: \.displaySections,
                   to: dataSource)
      .store(in: &cancellables)
  }

  static func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    return .list(using: configuration)
  }

}
