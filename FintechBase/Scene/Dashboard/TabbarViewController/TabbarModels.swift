//
//  TabbarModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Tabbar {
  // MARK: Use cases
  
  enum Something {
    struct Request {
    }
    struct Response {
    }
    struct ViewModel {
    }
  }
}

/*Set Tabbar Title*/
enum TabBarTitle: String, CaseIterable {
    case home
    case transaction
    case shopping
    case more
    case location
}
