//
//  ReplaceFasTagPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ReplaceFasTagPresentationLogic {
  func presentTagList(response: GetFastTag.Tag.Response)
  func presentApplyFastTag(response: ReplaceFastTag.ReplaceTag.Response)
  func presentVehicleNumber(number: String)
}

class ReplaceFasTagPresenter: ReplaceFasTagPresentationLogic {
    weak var viewController: ReplaceFasTagDisplayLogic?
    
    // MARK: Replace Tag List
    func presentTagList(response: GetFastTag.Tag.Response) {
        let viewModel = GetFastTag.Tag.ViewModel(replaceTagResultModel: response.replaceTagResultResponse?.result)
        viewController?.displayTagList(viewModel: viewModel)
    }
    
    // MARK: Apply Replace FastTag
    func presentApplyFastTag(response: ReplaceFastTag.ReplaceTag.Response) {
        let viewModel = ReplaceFastTag.ReplaceTag.ViewModel(replaceTagResultModel: response.replaceTagResultResponse)
        viewController?.displayReplaceFastTag(viewModel: viewModel)
    }
    
    /* Present Vehicle Number */
    func presentVehicleNumber(number: String) {
        viewController?.displayVehicleNumber(number: number)
    }
}
