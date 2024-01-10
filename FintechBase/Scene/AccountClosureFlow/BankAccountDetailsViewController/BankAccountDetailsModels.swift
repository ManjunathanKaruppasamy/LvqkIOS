//
//  BankAccountDetailsModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum BankAccountDetails {
    // MARK: Use cases
    
    enum Something {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}

struct AccountDetailsField {
    var title: String
    var placeholder: String
    var errorDescription: String?
}

struct ButtonData {
    var title: String
    var isEnable: Bool
}

struct BankAccountDetailsData {
    var accountNumber: String = ""
    var reAccountNumber: String = ""
    var ifscNumber: String = ""
    var benificiaryName: String = ""
}
