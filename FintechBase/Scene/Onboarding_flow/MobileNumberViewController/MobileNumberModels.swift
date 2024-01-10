//
//  MobileNumberModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum MobileNumberModel {
    // MARK: Use cases
    enum Customer {
        struct Request {
            var request: CheckRegisterModel?
        }
        struct Response {
            var response: CheckRegisterModel?
        }
        struct ViewModel {
            var viewModel: CheckRegisterModel?
        }
    }
}

enum CustomerStatus: String {
    case success = "success"
    case failed = "failed"
    case error = "error"
}

struct CheckRegisterModel: Mappable {
    var status: String?
    var error: String?
    var isAccountClosed: String?
    var result: String?
    var exception: Exception?
    var pagination: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        error <- map["error"]
        isAccountClosed <- map["isAccountClosed"]
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }

}

struct Exception: Mappable {
    var shortMessage: String?
    var detailMessage: String?
    var languageCode: String?
    var errorCode: String?
    var fieldErrors: String?
    var message: String?
    var localizedMessage: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        shortMessage <- map["shortMessage"]
        detailMessage <- map["detailMessage"]
        languageCode <- map["languageCode"]
        errorCode <- map["errorCode"]
        fieldErrors <- map["fieldErrors"]
        message <- map["message"]
        localizedMessage <- map["localizedMessage"]
    }

}

struct DigiLockerResponse: Mappable {
    var respcode: String?
    var status: String?
    var txnid: String?
    var respdesc: String?
    var kycdetails: Kycdetails?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        respcode <- map["respcode"]
        status <- map["status"]
        txnid <- map["txnid"]
        respdesc <- map["respdesc"]
        kycdetails <- map["kycdetails"]
    }

}

struct Kycdetails: Mappable {
    var address: String?
    var dob: String?
    var fname: String?
    var gender: String?
    var name: String?
    var pht: String?
    var uid: String?
    var aadhaarImg: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        address <- map["address"]
        dob <- map["dob"]
        fname <- map["fname"]
        gender <- map["gender"]
        name <- map["name"]
        pht <- map["pht"]
        uid <- map["uid"]
        aadhaarImg <- map["zipped_aadhaar_xml"]
    }

}

struct RegisterUserResponseData: Mappable {
    var status: String?
    var accessToken: String?
    var refreshToken: String?
    var statusCode: Int?
    var error: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
        statusCode <- map["statusCode"]
        error <- map["error"]
    }

}
