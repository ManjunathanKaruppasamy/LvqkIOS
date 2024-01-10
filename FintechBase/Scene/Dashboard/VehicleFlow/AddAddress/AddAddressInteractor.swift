//
//  AddAddressInteractor.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddAddressBusinessLogic {
    func doSomething(request: AddAddress.Something.Request)
}

protocol AddAddressDataStore {
    // var name: String { get set }
}

class AddAddressInteractor: AddAddressBusinessLogic, AddAddressDataStore {
    var presenter: AddAddressPresentationLogic?
    var worker: AddAddressWorker?
    // var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: AddAddress.Something.Request) {
        worker?.doSomeWork()
        
        let response = AddAddress.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
