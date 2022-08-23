//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import Common
import Cartography

class Cell: UICollectionViewListCell {

  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(label)

    let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
    let chevron = UIImageView(image: UIImage(systemName: "chevron.right",
                                             withConfiguration: configuration))
    contentView.addSubview(chevron)

    constrain(contentView, label, chevron) { contentView, label, chevron in
      label.leading == contentView.leading + 16
      label.top == contentView.top + 16
      label.bottom == contentView.bottom - 16
      chevron.trailing == contentView.trailing - 16
      chevron.centerY == contentView.centerY
    }

    label.font = .preferredFont(forTextStyle: .title3)
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

}
