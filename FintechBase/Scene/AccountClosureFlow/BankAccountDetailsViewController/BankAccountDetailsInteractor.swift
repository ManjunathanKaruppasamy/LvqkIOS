//
//  BankAccountDetailsInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BankAccountDetailsBusinessLogic {
    func getFieldDetails()
}

protocol BankAccountDetailsDataStore {
    // var name: String { get set }
}

class BankAccountDetailsInteractor: BankAccountDetailsBusinessLogic, BankAccountDetailsDataStore {
    var presenter: BankAccountDetailsPresentationLogic?
    var worker: BankAccountDetailsWorker?
    // var name: String = ""
    
    // MARK: Get Field Details
    func getFieldDetails() {
        let accountDetailsField: [AccountDetailsField] = [AccountDetailsField(title: AppLoacalize.textString.accountNumber, placeholder: AppLoacalize.textString.enter),
                                                          AccountDetailsField(title: AppLoacalize.textString.confirmAccountNumber, placeholder: AppLoacalize.textString.reEnter, errorDescription: AppLoacalize.textString.accountNumberMismatched),
                                                          AccountDetailsField(title: AppLoacalize.textString.ifscCode, placeholder: AppLoacalize.textString.enterIFSC, errorDescription: AppLoacalize.textString.invalidIFSC),
                                                          AccountDetailsField(title: AppLoacalize.textString.beneficiaryName, placeholder: AppLoacalize.textString.enterYourBeneficiaryName)]
        self.presenter?.presentFieldDetails(accountDetailsField: accountDetailsField)
    }
}
