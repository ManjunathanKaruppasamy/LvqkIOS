//
//  NegativeBalanceModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum NegativeBalance {
    // MARK: Use cases
    
    enum NegativeBalanceModel {
        struct Request {
        }
        struct Response {
        var getBalanceResponse: GetBalanceResponse?
        }
        struct ViewModel {
        var getBalanceResponse: GetBalanceResponse?
        }
    }
}
