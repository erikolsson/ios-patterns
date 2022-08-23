//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-23.
//

import UIKit

public protocol SectionWrapperType {
  associatedtype SectionIdentifierType: Hashable
  associatedtype ItemIdentifierType: Hashable

  var sectionIdentifier: SectionIdentifierType { get }
  var items: [ItemIdentifierType] { get }
}

public struct SectionWrapper<A, B>: SectionWrapperType, Equatable where A: Hashable, B: Hashable {
  public var sectionIdentifier: A
  public var items: [B]
  public init(sectionIdentifier: A, items: [B]) {
    self.sectionIdentifier = sectionIdentifier
    self.items = items
  }
}

extension Array where Element: SectionWrapperType {
  var asSnapshot: NSDiffableDataSourceSnapshot<Element.SectionIdentifierType, Element.ItemIdentifierType> {
    var snapshot = NSDiffableDataSourceSnapshot<Element.SectionIdentifierType, Element.ItemIdentifierType>()
    for section in self {
      snapshot.appendSections([section.sectionIdentifier])
      snapshot.appendItems(section.items,
                           toSection: section.sectionIdentifier)
    }
    return snapshot
  }
}
