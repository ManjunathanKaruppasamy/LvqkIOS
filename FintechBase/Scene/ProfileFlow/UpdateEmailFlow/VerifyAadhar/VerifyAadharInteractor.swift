//
//  VerifyAadharInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VerifyAadharBusinessLogic {
  func doSomething(request: VerifyAadhar.Something.Request)
}

protocol VerifyAadharDataStore {
  // var name: String { get set }
    var flowEnum: ModuleFlowEnum { get set }
}

class VerifyAadharInteractor: VerifyAadharBusinessLogic, VerifyAadharDataStore {
  var presenter: VerifyAadharPresentationLogic?
  var worker: VerifyAadharWorker?
  var flowEnum: ModuleFlowEnum = .none
  // var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: VerifyAadhar.Something.Request) {
    worker = VerifyAadharWorker()
    worker?.doSomeWork()
    
    let response = VerifyAadhar.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
