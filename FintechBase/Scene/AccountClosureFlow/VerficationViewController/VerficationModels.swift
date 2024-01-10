//
//  VerficationModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum Verfication {
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

enum FlowFromVC {
  case accountClosure, addVehicle, none
}

// MARK: Get Account Closure Response
struct GetAccountClosureResponseModel: Mappable {
    var status: String?
    var error: String?
    var statusCode: Int?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        error <- map["error"]
        statusCode <- map["statusCode"]
    }
}
