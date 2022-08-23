//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit

public extension UIActivityIndicatorView {
  var _isAnimating: Bool {
    set {
      if newValue {
        startAnimating()
      } else {
        stopAnimating()
      }
    }
    get {
      return self.isAnimating
    }
  }
}
