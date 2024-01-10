//
//  VerifyOTPModels.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum VerifyOTP {
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
