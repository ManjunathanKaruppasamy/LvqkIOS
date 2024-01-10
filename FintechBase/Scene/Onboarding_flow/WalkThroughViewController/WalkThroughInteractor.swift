//
//  WalkThroughInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol WalkThroughBusinessLogic {
  func doSomething(request: WalkThrough.Something.Request)
}

protocol WalkThroughDataStore {
  // var name: String { get set }
}

class WalkThroughInteractor: WalkThroughBusinessLogic, WalkThroughDataStore {
  var presenter: WalkThroughPresentationLogic?
  var worker: WalkThroughWorker?
  // var name: String = ""
  
  // MARK: Do something
  func doSomething(request: WalkThrough.Something.Request) {
    worker = WalkThroughWorker()
    worker?.doSomeWork()
    
    let response = WalkThrough.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
