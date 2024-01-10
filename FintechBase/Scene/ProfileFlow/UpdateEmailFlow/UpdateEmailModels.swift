//
//  UpdateEmailModels.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum UpdateEmail {
  // MARK: Use cases
  
  enum Validate {
    struct Request {
        var newEmailID: String?
        var reEnteredEmailID: String?
        var apiValidEmailRequestData: Bool?
    }
    struct Response {
        var isEmailValidation: Bool?
        var responseMsg: String?
        var apiValidEmailSuccessData: Bool?
        var email: String?
    }
    struct ViewModel {
        var isEmailValidation: Bool?
        var responseMsg: String?
        var email: String?
    }
  }
}
