//
//  LogoutInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 20/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LogoutBusinessLogic {
  func doSomething(request: Logout.Something.Request)
}

protocol LogoutDataStore {
  
}

class LogoutInteractor: LogoutBusinessLogic, LogoutDataStore {
  var presenter: LogoutPresentationLogic?
  var worker: LogoutWorker?

  // MARK: Do something
  func doSomething(request: Logout.Something.Request) {
    worker = LogoutWorker()
    worker?.doSomeWork()
    
    let response = Logout.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
