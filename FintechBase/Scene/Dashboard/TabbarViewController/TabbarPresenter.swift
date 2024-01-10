//
//  TabbarPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TabbarPresentationLogic {
    func presentTab(tabControllers: [UIViewController])
}

class TabbarPresenter: TabbarPresentationLogic {
  weak var viewController: TabbarDisplayLogic?
  
    // MARK: Present Tab
    func presentTab(tabControllers: [UIViewController]) {
        viewController?.getTabbarList(tablist: tabControllers)
    }
}
