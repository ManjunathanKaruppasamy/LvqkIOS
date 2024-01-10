//
//  TrackIssueModels.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 07/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum TrackIssue {
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

struct TrackIssueModel {
    var title: String?
    var list: [TrackIssueItem]?
    var img: String?
}

struct TrackIssueItem {
    var name: String?
    var amount: String?
    var status: String?
    var trackNumber: String?
    var issueNumber: String?
    var date: String?
}

struct DisputeEntityModel: Mappable {
    var result: [DisputeEntityResult]?
    var exception: String?
    var pagination: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }
}

struct DisputeEntityResult: Mappable {
    var created: Int?
    var changed: Double?
    var entityId: String?
    var txnRef: String?
    var disputeRef: String?
    var amount: String?
    var reason: String?
    var description: String?
    var status: String?
    var type: String?
    var extTxnId: String?
    var creator: String?
    var changer: String?
    var url: String?
    var url2: String?
    var disputeType: String?
    var businessEntityPkey: Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        created <- map["created"]
        changed <- map["changed"]
        entityId <- map["entityId"]
        txnRef <- map["txnRef"]
        disputeRef <- map["disputeRef"]
        amount <- map["amount"]
        reason <- map["reason"]
        description <- map["description"]
        status <- map["status"]
        type <- map["type"]
        extTxnId <- map["extTxnId"]
        creator <- map["creator"]
        changer <- map["changer"]
        url <- map["url"]
        url2 <- map["url2"]
        disputeType <- map["disputeType"]
        businessEntityPkey <- map["businessEntityPkey"]
    }

}
