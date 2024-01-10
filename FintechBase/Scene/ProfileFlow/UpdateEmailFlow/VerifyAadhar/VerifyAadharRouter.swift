//
//  VerifyAadharRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol VerifyAadharRoutingLogic {
    func routeToOtpVerificationVC()
}

protocol VerifyAadharDataPassing {
  var dataStore: VerifyAadharDataStore? { get }
}

class VerifyAadharRouter: NSObject, VerifyAadharRoutingLogic, VerifyAadharDataPassing {
    weak var viewController: VerifyAadharViewController?
    var dataStore: VerifyAadharDataStore?
    
    // MARK: Route to VerifyOtpVC
    func routeToOtpVerificationVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.otpVerifyVC) as? VerifyOTPViewController, let sourceVC = viewController {
            VerifyOTPConfigurator.configureModule(viewController: destinationVC)
            var destDataStore = destinationVC.router?.dataStore
            passDataToDestVC(sourceDS: dataStore, destinationDS: &destDataStore)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    // MARK: Navigation
    private func navigation(source: VerifyAadharViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .custom
            destination.modalTransitionStyle = .crossDissolve
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    // MARK: Passing Data to Update email flow
    private func passDataToDestVC(sourceDS: VerifyAadharDataStore?, destinationDS: inout VerifyOTPDataStore?) {
        destinationDS?.flowEnum = sourceDS?.flowEnum ?? .none
    }
}
