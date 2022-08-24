//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import Common

class LoadedViewController: StoreViewController<Loaded.State, Loaded.Action> {

  override func configureSubviews() {
    title = "Loaded"
    view.backgroundColor = UIColor.systemBackground
  }

}
