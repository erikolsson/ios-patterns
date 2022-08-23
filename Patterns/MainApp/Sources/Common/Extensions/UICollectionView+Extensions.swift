//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import Combine

public protocol DiffableListDataSourceType: AnyObject {
  associatedtype SectionIdentifier: Hashable
  associatedtype ItemIdentifier: Hashable

  func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>,
             animatingDifferences: Bool,
             completion: (() -> Void)?)
}

extension UICollectionViewDiffableDataSource: DiffableListDataSourceType {}
extension UITableViewDiffableDataSource: DiffableListDataSourceType {}

extension Subscribers {

  fileprivate class Apply<DataSource: DiffableListDataSourceType>: Subscriber, Cancellable {

    typealias Failure = Never
    private weak var dataSource: DataSource?
    private let animatingDifferences: Bool
    private let completion: (() -> Void)?

    init(dataSource: DataSource, animatingDifferences: Bool, completion: (() -> Void)?) {
      self.dataSource = dataSource
      self.animatingDifferences = animatingDifferences
      self.completion = completion
    }

    func receive(_ input: NSDiffableDataSourceSnapshot<DataSource.SectionIdentifier, DataSource.ItemIdentifier>) -> Subscribers.Demand {
      self.dataSource?.apply(input, animatingDifferences: animatingDifferences, completion: completion)
      return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {
    }

    func receive(subscription: Subscription) {
      subscription.request(.unlimited)
    }

    func cancel() {
      dataSource = nil
    }

  }

}

extension Publisher where Failure == Never {

  public func apply<DataSource: DiffableListDataSourceType>(to dataSource: DataSource,
                                                            animatingDifferences: Bool = true,
                                                            completion: (() -> Void)? = nil) ->
  AnyCancellable where Output == NSDiffableDataSourceSnapshot<DataSource.SectionIdentifier, DataSource.ItemIdentifier> {
    let apply = Subscribers.Apply<DataSource>(dataSource: dataSource,
                                              animatingDifferences: animatingDifferences,
                                              completion: completion)
    receive(subscriber: apply)
    return AnyCancellable(apply)
  }

}

public extension UICollectionView {

  func registerCellClass<T: UICollectionViewCell>(type: T.Type) {
    let description = String(describing: type)
    register(T.self, forCellWithReuseIdentifier: description)
  }

  func registerViewClass<T: UICollectionReusableView>(type: T.Type, kind: String) {
    let description = String(describing: type)
    register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: description)
  }

  func dequeue<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T {
    let description = String(describing: type)
    return dequeueReusableCell(withReuseIdentifier: description, for: indexPath) as! T
  }

  func dequeue<T: UICollectionReusableView>(type: T.Type,
                                            indexPath: IndexPath,
                                            kind: String) -> T {
    let description = String(describing: type)
    return dequeueReusableSupplementaryView(ofKind: kind,
                                            withReuseIdentifier: description,
                                            for: indexPath) as! T
  }
}
