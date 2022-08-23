//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-19.
//

import UIKit

public extension UIButton {
  var normalTitle: String? {
    get { title(for: .normal) }
    set { setTitle(newValue, for: .normal) }
  }
}
