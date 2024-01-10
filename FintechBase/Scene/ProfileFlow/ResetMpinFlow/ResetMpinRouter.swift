//
//  ResetMpinRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol ResetMpinRoutingLogic {
    func routeToVerifyOtpVC()
    func routeToInitialUserFlow()
}

protocol ResetMpinDataPassing {
  var dataStore: ResetMpinDataStore? { get }
}

class ResetMpinRouter: NSObject, ResetMpinRoutingLogic, ResetMpinDataPassing {
  weak var viewController: ResetMpinViewController?
  var dataStore: ResetMpinDataStore?
    
    // MARK: Route To VerifyOtpVC
    func routeToVerifyOtpVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.otpVerifyVC) as? VerifyOTPViewController, let sourceVC = viewController {
            VerifyOTPConfigurator.configureModule(viewController: destinationVC)
            var destinationDS = destinationVC.router?.dataStore
            passDataToVerifyOtpVC(sourceDS: dataStore, destinationDS: &destinationDS)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    // MARK: Passing Data to Otp flow
    private func passDataToVerifyOtpVC(sourceDS: ResetMpinDataStore?, destinationDS: inout VerifyOTPDataStore?) {
        destinationDS?.flowEnum = sourceDS?.flowEnum ?? .none
    }
    
    // MARK: Navigation
    private func navigation(source: ResetMpinViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .custom
            destination.modalTransitionStyle = .crossDissolve
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    // MARK: Route to Initial Flow
    func routeToInitialUserFlow() {
        viewController?.navigationController?.popToRootViewController(animated: false)
    }
}
