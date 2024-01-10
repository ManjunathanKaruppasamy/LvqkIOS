//
//  ReplaceFasTagModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

struct ReplaceFastTags: Mappable {
    var status: String?
    var result: [ReplaceTagResult]?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
    }
}

struct ReplaceTagResult: Mappable {
    var id: String?
    var reason: String?
    var value: Int?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["_id"]
        reason <- map["reason"]
        value <- map["__v"]
    }
}

enum ReplaceFastTag {
    // MARK: Use cases
    enum ReplaceTag {
        struct Request {
        }
        struct Response {
            var replaceTagResultResponse: FastTagReplaceCard?
        }
        struct ViewModel {
            var replaceTagResultModel: FastTagReplaceCard?
        }
    }
}

enum GetFastTag {
    // MARK: Use cases
    enum Tag {
        struct Request {
        }
        struct Response {
            var replaceTagResultResponse: ReplaceFastTags?
        }
        struct ViewModel {
            var replaceTagResultModel: [ReplaceTagResult]?
        }
    }
}

struct FastTagReplaceCard: Mappable {
    var status: String?
    var result: ReplaceFastTagResult?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
    }

}

struct ReplaceFastTagResult: Mappable {
    var code: Bool?
    var result: String?
    var notificationException: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        code <- map["code"]
        result <- map["result"]
        notificationException <- map["notificationException"]
    }

}
enum DisputeTag: String, CaseIterable {
    case incorrectTollCharges = "Incorrect toll charges"
    case duplicateTransaction = "Duplicate Transaction"
    case technicalIssue = "Technical issue"
    case chargedTwice = "Charged twice"
    case otherIssues = "Other Issues"
    case infcorrectTollCharges = "Incorrect toll chargese"
    case duplifcateTransaction = "Duplicate Transactieon"
    case technficalIssue = "Technical isesue"
    case chargfedTwice = "Charged twiece"
    case otherIfssues = "Other Isesues"
    case incorrefctTollCharges = "Incorrsect toll charges"
    case duplicafteTransaction = "Duplicsate Transaction"
    case technicfalIssue = "Techniscal issue"
    case chargedfTwice = "Charsged twice"
    case otherIsfsues = "Otsher Issues"
}
