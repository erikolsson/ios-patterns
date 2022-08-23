//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import ComposableArchitecture
import Combine
import UIKit

public extension ViewStore {

  func bind<A, B: Equatable>(_ from: KeyPath<State, B>,
                             to keyPath: ReferenceWritableKeyPath<A, B>,
                             on: A) -> AnyCancellable {
    return publisher.upstream.map(from)
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .assign(to: keyPath, on: on)
  }

  func bind<A, B: Equatable>(_ from: KeyPath<State, B>,
                             to keyPath: ReferenceWritableKeyPath<A, B?>,
                             on: A) -> AnyCancellable {
    return publisher.upstream.map(from)
      .map(Optional.some)
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .assign(to: keyPath, on: on)
  }

  func bind<SectionIdentifier,
            ItemIdentifier,
            DataSource: DiffableListDataSourceType>(sections sectionsKeyPatch: KeyPath<State, [SectionWrapper<SectionIdentifier, ItemIdentifier>]>,
                                                    to dataSource: DataSource) -> AnyCancellable where DataSource.SectionIdentifier == SectionIdentifier,
                                                                                                       DataSource.ItemIdentifier == ItemIdentifier {
    return publisher.upstream.map(sectionsKeyPatch)
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .map(\.asSnapshot)
      .apply(to: dataSource)
  }

}
