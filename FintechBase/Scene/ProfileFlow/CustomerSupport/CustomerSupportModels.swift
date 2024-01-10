//
//  CustomerSupportModels.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 06/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum CustomerSupport {
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

struct CusSupportModel {
    var name: String?
    var list: [SupportList]?
    var type: String?
}

struct SupportList {
    var img: String?
    var title: String?
    var clickValue: String?
    var id: Int?
}
