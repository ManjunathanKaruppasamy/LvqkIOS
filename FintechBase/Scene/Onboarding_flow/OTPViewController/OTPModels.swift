//
//  OTPModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum OTP {
  // MARK: Use cases
  
  enum OTPModel {
    struct Request {
    }
    struct Response {
        var getOTPResponse: GetOTPResponseData?
        var validateOTPResponse: ValidateOTPResponseData?
    }
    struct ViewModel {
        var getOTPViewModel: GetOTPResponseData?
        var validateOTPViewModel: ValidateOTPResponseData?
    }
  }
}

struct GetOTPResponseData: Mappable {
    var status: String?
    var result: Result?
    var exception: Exception?
    var pagination: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }

}

struct Result: Mappable {
    var success: Bool?
    var isCustomerExists: Bool?
    var customerId: String?
    var customerName: String?
    var otp: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        success <- map["success"]
        isCustomerExists <- map["isCustomerExists"]
        customerId <- map["customerId"]
        customerName <- map["customerName"]
        otp <- map["otp"]
    }

}

struct ValidateOTPResponseData: Mappable {
    var status: String?
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
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
        statusCode <- map["statusCode"]
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }

}

struct OTPUIData {
    var number: String?
    var isFromForgot: Bool?
    var isFromAccountClose: Bool?
}
