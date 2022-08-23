//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import Common

class LoadedViewController: StoreViewController<LoadedState, LoadedAction> {

  override func configureSubviews() {
    title = "Loaded"
    view.backgroundColor = UIColor.systemBackground
  }

}
