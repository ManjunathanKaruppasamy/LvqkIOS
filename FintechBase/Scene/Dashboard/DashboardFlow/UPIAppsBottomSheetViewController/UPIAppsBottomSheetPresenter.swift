//
//  UPIAppsBottomSheetPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/06/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UPIAppsBottomSheetPresentationLogic {
    func presentUPIAppsList(upiAppsList: [UPIAppsData])
    func presentGetReferenceId(response: UPIAppsBottomSheet.UPIAppsBottomSheetModel.Response)
    func presentTransactionDetails(response: UPIAppsBottomSheet.UPIAppsBottomSheetModel.Response)
}

class UPIAppsBottomSheetPresenter: UPIAppsBottomSheetPresentationLogic {
    weak var viewController: UPIAppsBottomSheetDisplayLogic?
    
    func presentUPIAppsList(upiAppsList: [UPIAppsData]) {
        viewController?.displayUPIAppsList(upiAppsList: upiAppsList)
    }
    
    func presentGetReferenceId(response: UPIAppsBottomSheet.UPIAppsBottomSheetModel.Response) {
        viewController?.displayGetReferenceId(viewModel: UPIAppsBottomSheet.UPIAppsBottomSheetModel.ViewModel(getReferenceIdResponse: response.getReferenceIdResponse))
    }
    
    func presentTransactionDetails(response: UPIAppsBottomSheet.UPIAppsBottomSheetModel.Response) {
        viewController?.displayTransactionDetails(viewModel: UPIAppsBottomSheet.UPIAppsBottomSheetModel.ViewModel(fetchTransactionResponse: response.fetchTransactionResponse))
    }
}
