//
//  AadhaarVerificationInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/11/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AadhaarVerificationBusinessLogic {
    func doSomething(request: AadhaarVerification.Something.Request)
}

protocol AadhaarVerificationDataStore {
    // var name: String { get set }
}

class AadhaarVerificationInteractor: AadhaarVerificationBusinessLogic, AadhaarVerificationDataStore {
    var presenter: AadhaarVerificationPresentationLogic?
    var worker: AadhaarVerificationWorker?
    // var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: AadhaarVerification.Something.Request) {
        worker?.doSomeWork()
        
        let response = AadhaarVerification.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
