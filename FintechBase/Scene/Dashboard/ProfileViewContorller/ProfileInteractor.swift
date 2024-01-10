//
//  ProfileInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfileBusinessLogic {
  func doSomething(request: Profile.Something.Request)
}

protocol ProfileDataStore {
  // var name: String { get set }
}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
  var presenter: ProfilePresentationLogic?
  var worker: ProfileWorker?
  // var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Profile.Something.Request) {
    worker = ProfileWorker()
    worker?.doSomeWork()
    
    let response = Profile.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
