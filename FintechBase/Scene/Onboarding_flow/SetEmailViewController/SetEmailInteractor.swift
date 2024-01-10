//
//  SetEmailInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SetEmailBusinessLogic {
    func doSomething(request: SetEmail.Something.Request)
}

protocol SetEmailDataStore {
//     var name: String { get set }
}

class SetEmailInteractor: SetEmailBusinessLogic, SetEmailDataStore {
    var presenter: SetEmailPresentationLogic?
    var worker: SetEmailWorker?
//     var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: SetEmail.Something.Request) {
        worker?.doSomeWork()
        
        let response = SetEmail.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
