//
//  StartVideoKYCModels.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum StartVideoKYC {
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

struct NotesListModel {
    var titleMessage: String?
    var id: Int?
    var status: Bool?
    
    init(titleMessage: String?, id: Int?, status: Bool = false) {
        self.titleMessage = titleMessage
        self.id = id
        self.status = status
    }
}

struct VKYCResponse: Mappable {
    var status: String?
    var result: VKYCResult?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
    }

}

struct VKYCResult: Mappable {
    var respcode: String?
    var respdesc: String?
    var vciplink: String?
    var qrimage: String?
    var vcipid: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        respcode <- map["respcode"]
        respdesc <- map["respdesc"]
        vciplink <- map["vciplink"]
        qrimage <- map["qrimage"]
        vcipid <- map["vcipid"]
    }

}
