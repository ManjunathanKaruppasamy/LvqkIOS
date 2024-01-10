//
//  CommonMpinModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

// swiftlint:disable nesting
enum CommonMpin {
  // MARK: Use cases
  
  enum CommonMpinModels {
    struct Request {
        var enteredMpin: String?
    }
    struct Response {
        var mpinResponseData: MPINResponseData?
        var loginMpinResponseData: LoginMpinResponseData?
    }
    struct ViewModel {
        var mpinViewModelData: MPINResponseData?
        var loginMpinViewModelData: LoginMpinResponseData?
    }
  }
}

enum MpinType {
    case enterMpin
    case createMpin
    case changeMpin
}

struct MpinInitialData {
    var type: MpinType
    var isFromForgot: Bool
    var isFromDOB: Bool
}
struct MPINResponseData: Mappable {
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

struct LoginMpinResponseData: Mappable {
    var status: String?
    var error: String?
    var accessToken: String?
    var refreshToken: String?
    var statusCode: Int?
    var result: Result?
    var exception: Exception?
    var pagination: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        error <- map["error"]
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
        statusCode <- map["statusCode"]
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }

}
