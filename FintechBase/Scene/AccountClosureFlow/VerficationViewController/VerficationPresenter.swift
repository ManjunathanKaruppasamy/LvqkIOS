//
//  VerficationPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VerficationPresentationLogic {
    func presentAccountClosure(isSuccess: Bool, getAccountClosureResponseModel: GetAccountClosureResponseModel?)
}

class VerficationPresenter: VerficationPresentationLogic {
    weak var viewController: VerficationDisplayLogic?
    
    // MARK: present Account Closure
    func presentAccountClosure(isSuccess: Bool, getAccountClosureResponseModel: GetAccountClosureResponseModel?) {
        self.viewController?.displayAccountClosure(isSuccess: isSuccess, getAccountClosureResponseModel: getAccountClosureResponseModel)
    }
}
