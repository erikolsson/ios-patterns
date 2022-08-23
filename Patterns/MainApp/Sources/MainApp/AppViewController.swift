//
//  AppViewController.swift
//  Patterns
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import ComposableArchitecture
import Common
import Cartography
import LoadAndNavigate
import NavigateAndLoad
import Downloads
import Form

public class AppViewController: StoreViewController<AppState, AppAction> {

  let collectionView = UICollectionView(frame: .zero,
                                        collectionViewLayout: AppViewController.collectionViewLayout())
  lazy var dataSource = UICollectionViewDiffableDataSource<Int, DisplayItem>(collectionView: collectionView,
                                                                             cellProvider: { cv, indexPath, item in
    let cell = cv.dequeue(type: Cell.self, indexPath: indexPath)
    cell.label.text = item.title
    return cell
  })

  public override func configureSubviews() {
    title = "Patterns"
    view.addSubview(collectionView)
    collectionView.registerCellClass(type: Cell.self)
    collectionView.delegate = self
    constrain(view, collectionView) { $1.edges == $0.edges }
  }

  public override func configureStateObservation() {
    viewStore.bind(sections: \.displaySections,
                   to: dataSource)
      .store(in: &cancellables)
  }

  static func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    return UICollectionViewCompositionalLayout.list(using: configuration)
  }

}

extension AppViewController: UICollectionViewDelegate {

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    guard let identifier = dataSource.itemIdentifier(for: indexPath) else { return }
    switch identifier {
    case .loadAndNavigate:
      let vc = LoadAndNavigateViewController(store: store.scope(state: \.loadAndNavigate,
                                                                action: AppAction.loadAndNavigate))
      navigationController?.pushViewController(vc, animated: true)

    case .navigateAndLoad:
      let vc = NavigateAndLoadViewController(store: store.scope(state: \.navigateAndLoad,
                                                                action: AppAction.navigateAndLoad))
      navigationController?.pushViewController(vc, animated: true)

    case .cellStates:
      let vc = DownloadsViewController(store: store.scope(state: \.cells,
                                                      action: AppAction.downloads))
      navigationController?.pushViewController(vc, animated: true)

    case .form:
      let vc = FormViewController(store: store.scope(state: \.form,
                                                     action: AppAction.form))
      navigationController?.pushViewController(vc, animated: true)
    }
  }

}
