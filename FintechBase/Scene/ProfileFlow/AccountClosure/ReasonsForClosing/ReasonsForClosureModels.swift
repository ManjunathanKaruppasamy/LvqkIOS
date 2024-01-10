//
//  ReasonsForClosureModels.swift
//  FintechBase
//
//  Created by Sravani Madala on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum ReasonsForClosure {
    // MARK: Use cases
    
    enum ReasonsForClosureModel {
        struct Request {
        }
        struct Response {
            var closureReasonsModel: ClosureReasonsModel?
        }
        struct ViewModel {
            var closureReasonsModel: ClosureReasonsModel?
        }
    }
}

struct ClosureReasonsModel: Mappable {
    var status: String?
    var result: [ClosureReasonsResult]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
    }

}

struct ClosureReasonsResult: Mappable {
    var id: String?
    var reason: String?
    var version: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["_id"]
        reason <- map["reason"]
        version <- map["__v"]
    }

}

class AccountClosureData {
    static var instance: AccountClosureData?

    class var sharedInstace: AccountClosureData {
        if instance == nil {
            instance = AccountClosureData()
        }
        return instance!
    }
    var closureReason: String = ""
    var accountNo: String = ""
    var ifscCode: String = ""
    var beneficiaryName: String = ""
    var addressProofFront: String = ""
    var addressProofBack: String = ""
    var idProofFront: String = ""
    var idProofBack: String = ""
    var bankProof: String = ""
    var isNegativeBalnce = false

    func destroy() {
        AccountClosureData.instance = nil
    }
    
    init() {
        self.closureReason = ""
        self.accountNo = ""
        self.ifscCode = ""
        self.beneficiaryName = ""
        self.addressProofFront = ""
        self.addressProofBack = ""
        self.idProofFront = ""
        self.idProofBack = ""
        self.bankProof = ""
        self.isNegativeBalnce = false
    }
    
    deinit {
        print("Class Deinitied")
    }
}
