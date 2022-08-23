//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-22.
//

import UIKit
import Cartography
import Combine
import Common

class TextCell: UICollectionViewListCell {

  let label = UILabel()
  let textField = UITextField()
  var cancellables = Set<AnyCancellable>()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(label)
    contentView.addSubview(textField)

    constrain(contentView, label, textField) { contentView, label, textField in
      label.leading == contentView.leadingMargin
      label.top == contentView.top + 16
      label.bottom == contentView.bottom - 16

      textField.trailing == contentView.trailingMargin
      textField.centerY == contentView.centerY
      textField.leading == contentView.centerX
    }

    textField.backgroundColor = .lightGray
    textField.textColor = .black
  }

  func configure(title: String, binding: TwoWayBinding<String>) {
    binding.attach(to: \.text, on: textField)
      .store(in: &cancellables)
    label.text = title
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    cancellables.removeAll()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

}
