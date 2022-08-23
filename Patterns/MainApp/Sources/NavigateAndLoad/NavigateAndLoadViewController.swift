//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import Common

public class NavigateAndLoadViewController: StoreViewController<NavigateAndLoadState, NavigateAndLoadAction> {

  public override func configureSubviews() {
    title = "Navigate and Load"
    view.backgroundColor = UIColor.systemBackground
  }

}
