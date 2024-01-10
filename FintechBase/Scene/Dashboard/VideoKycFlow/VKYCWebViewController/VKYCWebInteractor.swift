//
//  VKYCWebInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/05/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VKYCWebBusinessLogic {
    func getVideoKYCurl()
}

protocol VKYCWebDataStore {
    var loadLink: String { get set }
}

class VKYCWebInteractor: VKYCWebBusinessLogic, VKYCWebDataStore {
    var presenter: VKYCWebPresentationLogic?
    var worker: VKYCWebWorker?
    var loadLink: String = ""
    
    // MARK: Get VKYC Link
    func getVideoKYCurl() {
        presenter?.presentLoadLink(linkString: self.loadLink)
    }
}
