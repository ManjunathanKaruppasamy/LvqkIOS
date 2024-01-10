//
//  FilterListBottomSheetInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FilterListBottomSheetBusinessLogic {
    func getFilterListData()
}

protocol FilterListBottomSheetDataStore {
    var filterListData: [FilterListData]? { get set }
    var filterState: FilterState? { get set }
    var selectedIndex: Int? { get set }
}

class FilterListBottomSheetInteractor: FilterListBottomSheetBusinessLogic, FilterListBottomSheetDataStore {
    var presenter: FilterListBottomSheetPresentationLogic?
    var worker: FilterListBottomSheetWorker?
    var filterListData: [FilterListData]?
    var filterState: FilterState?
    var selectedIndex: Int?
    
    // MARK: Get FilterList Data
    func getFilterListData() {
        let response = FilterListBottomSheet.FilterListBottomSheetModel.Response(filterListData: self.filterListData ?? [], filterState: self.filterState ?? .dateFilter)
        presenter?.presentFilterListData(response: response, selectedIndex: self.selectedIndex)
    }
}
