//
//  OTPRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol OTPRoutingLogic {
    func routeToNextVC(isFromForgot: Bool)
}

protocol OTPDataPassing {
  var dataStore: OTPDataStore? { get }
}

class OTPRouter: NSObject, OTPRoutingLogic, OTPDataPassing {
  weak var viewController: OTPViewController?
  var dataStore: OTPDataStore?
    
    // MARK: Route To NextVC by CallBack
    func routeToNextVC(isFromForgot: Bool) {
        self.viewController?.dismiss(animated: false, completion: {
            self.viewController?.verifyOTPTapped?(self.viewController?.enteredOTP ?? "", isFromForgot)
        })
    }
}
