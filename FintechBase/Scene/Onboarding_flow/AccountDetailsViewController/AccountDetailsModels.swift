//
//  AccountDetailsModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum AccountDetails {
    // MARK: Use cases
    
    enum FetchList {
        struct Request {
        }
        struct Response {
            var accountDetails: [AccountDetailsData]?
            var accountDetailsRespone: AccountDetailsRespone?
            var registerUserResponseData: RegisterUserResponseData?
        }
        struct ViewModel {
            var accountDetails: [AccountDetailsData]?
            var accountDetailsViewModel: AccountDetailsRespone?
            var registerUserResponseData: RegisterUserResponseData?
        }
    }
}
enum UserState {
    case new, old, none
}

struct AccountDetailsData {
    var title: String?
    var description: String?
}

struct AccountDetailsRespone: Mappable {
    var status: String?
    var error: String?
    var result: AccountDetailsResult?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        error <- map["error"]
        result <- map["result"]
    }
    
}

struct AccountDetailsResult: Mappable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var name: String?
    var mobile: Int?
    var programs: [String]?
    var email: String?
    var appGuid: String?
    var dob: String?
    var city: String?
    var state: String?
    var pincode: Int?
    var address: String?
    var limit: Int?
    var customerType: String?
    var version: Int?
    var entityid: String?
    var kycStatus: String?
    var mpin: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["_id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        name <- map["name"]
        mobile <- map["mobile"]
        programs <- map["programs"]
        email <- map["email"]
        appGuid <- map["appGuid"]
        dob <- map["dob"]
        city <- map["city"]
        state <- map["state"]
        pincode <- map["pincode"]
        address <- map["address"]
        limit <- map["limit"]
        customerType <- map["customerType"]
        version <- map["__v"]
        entityid <- map["entityid"]
        kycStatus <- map["kycStatus"]
        mpin <- map["mpin"]
    }
    
}
