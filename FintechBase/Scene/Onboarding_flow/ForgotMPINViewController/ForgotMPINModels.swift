//
//  ForgotMPINModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum ForgotMPIN {
  // MARK: Use cases
  
  enum ForgotMPINModel {
    struct Request {
        var forgotMPINRequest: ForgotMPINRequest?
    }
    struct Response {
        var response: ForgotMPINResponse?
    }
    struct ViewModel {
        var viewModel: ForgotMPINResponse?
    }
  }
}

struct ForgotMPINRequest {
    var mobile: String
    var dob: String
}

struct ForgotMPINResponse: Mappable {
    var status: String?
    var result: Result?
    var error: String?
    var statusCode: Int?
    var exception: Exception?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
        error <- map["error"]
        statusCode <- map["statusCode"]
        exception <- map["exception"]
    }

}
