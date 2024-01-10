//
//  AccountClosureModels.swift
//  FintechBase
//
//  Created by Sravani Madala on 26/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum AccountClosure {
    // MARK: Use cases
    
    enum AccountModel {
        struct Request {
        }
        struct Response {
            let response: RequestCallBackResponse?
        }
        struct ViewModel {
            let viewModel: RequestCallBackResponse?
        }
    }
}

struct RequestCallBackResponse: Mappable {
    var status: String?
    var code: Int?
    var result: String?
    var notificationException: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        code <- map["code"]
        result <- map["result"]
        notificationException <- map["notificationException"]
    }

}
