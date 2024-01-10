//
//  FilterListBottomSheetModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum FilterListBottomSheet {
  // MARK: Use cases
  
  enum FilterListBottomSheetModel {
    struct Request {
    }
    struct Response {
        var filterListData = [FilterListData]()
        var filterState: FilterState?
    }
    struct ViewModel {
        var filterListData = [FilterListData]()
        var filterState: FilterState?
    }
  }
}

struct FilterListData {
    var title: String?
    var month: Int?
}

enum FilterState {
    case dateFilter
    case normalFilter
}
