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

public class DownloadsViewController: StoreViewController<Downloads.State, Downloads.Action> {

  typealias SectionWrapperType = SectionWrapper<Int, DisplayItem>
  let collectionView = UICollectionView(frame: .zero,
                                        collectionViewLayout: DownloadsViewController.collectionViewLayout())
  lazy var dataSource = UICollectionViewDiffableDataSource<Int, DisplayItem>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in

    let cell = collectionView.dequeue(type: DownloadCell.self, indexPath: indexPath)
    guard let store = self?.store else {
      return cell
    }

    switch itemIdentifier {
    case let .download(id: id):
      cell.configureOptional(with: store.scope(state: \.downloads[id: id],
                                               action: { Downloads.Action.cell(id: id, action: $0)} ))
    }
    return cell
  }

  public override func configureSubviews() {
    view.addSubview(collectionView)

    collectionView.registerCellClass(type: DownloadCell.self)
    constrain(view, collectionView) { $1.edges == $0.edges }
  }

  public override func configureStateObservation() {
    viewStore.bind(sections: \.displaySections,
                   to: dataSource)
    .store(in: &cancellables)
    
    viewStore.send(.viewDidLoad)
  }

  static func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .absolute(80))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .absolute(80))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                 subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }

}
