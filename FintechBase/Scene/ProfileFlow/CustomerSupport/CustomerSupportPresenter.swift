//
//  CustomerSupportPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 06/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CustomerSupportPresentationLogic {
    func presentSupportListData(response: [CusSupportModel], flowEnum: ModuleFlowEnum)
}

class CustomerSupportPresenter: CustomerSupportPresentationLogic {
  weak var viewController: CustomerSupportDisplayLogic?
  
  // MARK: Present SupportList Data
    func presentSupportListData(response: [CusSupportModel], flowEnum: ModuleFlowEnum) {
        viewController?.displaySupportListData(response: response, flowEnum: flowEnum)
    }
}
