//
//  FilterListBottomSheetPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FilterListBottomSheetPresentationLogic {
  func presentFilterListData(response: FilterListBottomSheet.FilterListBottomSheetModel.Response, selectedIndex: Int?)
}

class FilterListBottomSheetPresenter: FilterListBottomSheetPresentationLogic {
  weak var viewController: FilterListBottomSheetDisplayLogic?
  
  // MARK: Present FilterList Data
  func presentFilterListData(response: FilterListBottomSheet.FilterListBottomSheetModel.Response, selectedIndex: Int?) {
      let viewModel = FilterListBottomSheet.FilterListBottomSheetModel.ViewModel(filterListData: response.filterListData, filterState: response.filterState)
    viewController?.displayFilterListData(viewModel: viewModel, selectedIndex: selectedIndex)
  }
}
