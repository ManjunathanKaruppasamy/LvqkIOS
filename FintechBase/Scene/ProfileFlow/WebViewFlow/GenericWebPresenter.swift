//
//  GenericWebPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 17/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol GenericWebPresentationLogic {
  func presentInitialUIAttributes(flowEnum: ModuleFlowEnum, urlString: String)
}

class GenericWebPresenter: GenericWebPresentationLogic {
  weak var viewController: GenericWebDisplayLogic?
  
  // MARK: Present Initial UIAttributes
    func presentInitialUIAttributes(flowEnum: ModuleFlowEnum, urlString: String) {
        viewController?.displayUIAttributes(flowEnum: flowEnum, urlString: urlString)
    }
}
