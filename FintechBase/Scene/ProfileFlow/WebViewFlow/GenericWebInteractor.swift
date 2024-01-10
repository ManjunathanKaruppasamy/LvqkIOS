//
//  GenericWebInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 17/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol GenericWebBusinessLogic {
    func getWebviewUIAttributes()
}

protocol GenericWebDataStore {
    var flowEnum: ModuleFlowEnum { get set }
    var url: String { get set }
}

class GenericWebInteractor: GenericWebBusinessLogic, GenericWebDataStore {
  var presenter: GenericWebPresentationLogic?
  var worker: GenericWebWorker?
  var flowEnum: ModuleFlowEnum = .none
  var url: String = ""
  
  // MARK: Get Webview UIAttributes
    func getWebviewUIAttributes() {
        presenter?.presentInitialUIAttributes(flowEnum: self.flowEnum, urlString: self.url)
    }
}
