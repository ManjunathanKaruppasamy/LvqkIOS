//
//  VerifyOTPRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol VerifyOTPRoutingLogic {
    func routeToUpdateEmailVC()
    func routeToResetMpinVC()
    func routeToInitialUserFlow()
}

protocol VerifyOTPDataPassing {
  var dataStore: VerifyOTPDataStore? { get }
}

class VerifyOTPRouter: NSObject, VerifyOTPRoutingLogic, VerifyOTPDataPassing {
  weak var viewController: VerifyOTPViewController?
  var dataStore: VerifyOTPDataStore?
    
    // MARK: Route Update Email VC
    func routeToUpdateEmailVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.updateEmailVC) as? UpdateEmailViewController, let sourceVC = viewController {
            UpdateEmailConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    // MARK: Route to Reset Mpin VC
    func routeToResetMpinVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.resetMpinVC) as? ResetMpinViewController, let sourceVC = viewController {
            ResetMpinConfigurator.configureModule(viewController: destinationVC)
            var destinationDS = destinationVC.router?.dataStore
            passDataToResetMpinVC(sourceDS: dataStore, destinationDS: &destinationDS)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    // MARK: Navigation
    private func navigation(source: VerifyOTPViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .custom
            destination.modalTransitionStyle = .crossDissolve
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    // MARK: Passing Data to Webview
    private func passDataToResetMpinVC(sourceDS: VerifyOTPDataStore?, destinationDS: inout ResetMpinDataStore?) {
        destinationDS?.flowEnum = sourceDS?.flowEnum ?? .none
    }
    
    // MARK: Route to Initial Flow
    func routeToInitialUserFlow() {
        self.viewController?.dismiss(animated: false, completion: {
            if let topViewController = UIApplication.getTopViewController() {
                    topViewController.navigationController?.popToRootViewController(animated: false)
            }
        })
    }
}
