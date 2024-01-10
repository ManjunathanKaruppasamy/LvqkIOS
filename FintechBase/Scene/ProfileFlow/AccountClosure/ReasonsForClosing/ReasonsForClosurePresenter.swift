//
//  ReasonsForClosurePresenter.swift
//  FintechBase
//
//  Created by Sravani Madala on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ReasonsForClosurePresentationLogic {
    func presentClosureReasons(response: ReasonsForClosure.ReasonsForClosureModel.Response)
}

class ReasonsForClosurePresenter: ReasonsForClosurePresentationLogic {
    weak var viewController: ReasonsForClosureDisplayLogic?
    
    // MARK: Closure Reasons
    func presentClosureReasons(response: ReasonsForClosure.ReasonsForClosureModel.Response) {
        let viewModel = ReasonsForClosure.ReasonsForClosureModel.ViewModel(closureReasonsModel: response.closureReasonsModel)
        viewController?.displayClosureReasonsResponse(viewModel: viewModel)
    }
}
