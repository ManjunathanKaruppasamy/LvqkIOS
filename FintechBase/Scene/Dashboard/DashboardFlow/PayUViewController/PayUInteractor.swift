//
//  PayUInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 24/04/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PayUBusinessLogic {
    func getLoadLink()
}

protocol PayUDataStore {
    var isAccountClose: Bool? { get set }
    var loadLink: String { get set }
}

class PayUInteractor: PayUBusinessLogic, PayUDataStore {
    var presenter: PayUPresentationLogic?
    var worker: PayUWorker?
    var loadLink: String = ""
    var isAccountClose: Bool?
    
    // MARK: Get PayUEntry Link
    func getLoadLink() {
        presenter?.presentLoadLink(linkString: self.loadLink, isAccountClose: self.isAccountClose ?? false)
    }
}
