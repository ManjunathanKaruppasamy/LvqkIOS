//
//  UpdateEmailRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol UpdateEmailRoutingLogic {
    func routeToVerifyOtpVC()
}

protocol UpdateEmailDataPassing {
  var dataStore: UpdateEmailDataStore? { get }
}

class UpdateEmailRouter: NSObject, UpdateEmailRoutingLogic, UpdateEmailDataPassing {
  weak var viewController: UpdateEmailViewController?
  var dataStore: UpdateEmailDataStore?
    
    /* Route to VerifyOtpVC */
    func routeToVerifyOtpVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.otpVerifyVC) as? VerifyOTPViewController, let sourceVC = viewController {
            VerifyOTPConfigurator.configureModule(viewController: destinationVC)
            var destinationDS = destinationVC.router?.dataStore
            passDataToVerifyOtpVC(sourceDS: dataStore, destinationDS: &destinationDS)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    // MARK: Passing Data to Otp flow
    private func passDataToVerifyOtpVC(sourceDS: UpdateEmailDataStore?, destinationDS: inout VerifyOTPDataStore?) {
        destinationDS?.flowEnum = sourceDS?.flowEnum ?? .none
        destinationDS?.email = sourceDS?.email ?? ""
    }
    
    // MARK: Navigation
    private func navigation(source: UpdateEmailViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
