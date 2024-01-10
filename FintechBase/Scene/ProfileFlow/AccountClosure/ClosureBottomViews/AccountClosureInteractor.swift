//
//  AccountClosureInteractor.swift
//  FintechBase
//
//  Created by Sravani Madala on 26/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AccountClosureBusinessLogic {
    func fetchRequestCallBackApi()
    
}

protocol AccountClosureDataStore {
    // var name: String { get set }
}

class AccountClosureInteractor: AccountClosureBusinessLogic, AccountClosureDataStore {
    var presenter: AccountClosurePresentationLogic?
    var worker: AccountClosureWorker?
    // var name: String = ""
    
    // MARK: Fetch Request Call Back Api
    func fetchRequestCallBackApi() {
        let requestDict = [
            "name": userName,
            "mobile": userMobileNumber,
            "entityId": ENTITYID
        ]
        worker?.fetchRequestCallBackApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                self.presenter?.presentRequestCallBackresponse(response: AccountClosure.AccountModel.Response(response: response))
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
