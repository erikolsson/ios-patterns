//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-19.
//

import UIKit
import Cartography
import Combine
import Common
import ComposableArchitecture

class ToggleCell: UICollectionViewListCell {

  let label = UILabel()
  let toggle = UISwitch()
  var cancellables = Set<AnyCancellable>()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(label)
    contentView.addSubview(toggle)

    constrain(contentView, label, toggle) { contentView, label, toggle in
      label.leading == contentView.leadingMargin
      label.top == contentView.top + 16
      label.bottom == contentView.bottom - 16

      toggle.trailing == contentView.trailingMargin
      toggle.centerY == contentView.centerY
    }
  }

  func configure(title: String, binding: TwoWayBinding<Bool>) {
    label.text = title
    binding.attach(to: \.isOn, on: toggle, events: .valueChanged)
      .store(in: &cancellables)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    cancellables.removeAll()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

}
