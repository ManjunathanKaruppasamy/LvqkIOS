//
//  VKYCWebPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/05/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VKYCWebPresentationLogic {
    func presentLoadLink(linkString: String)
}

class VKYCWebPresenter: VKYCWebPresentationLogic {
  weak var viewController: VKYCWebDisplayLogic?
  
    // MARK: Present VKYC Link
    func presentLoadLink(linkString: String) {
      viewController?.displayLoadLink(linkString: linkString)
    }
}
