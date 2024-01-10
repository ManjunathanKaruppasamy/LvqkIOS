//
//  AddMoneyModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum AddMoney {
  // MARK: Use cases
  
  enum AddMoneyModel {
    struct Request {
    }
    struct Response {
        var payUResponse: PayUResponse
    }
    struct ViewModel {
        var payUResponse: PayUResponse
    }
  }
}

struct PayUResponse: Mappable {
    var status: String?
    var result: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
    }
}
