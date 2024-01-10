//
//  ForgotMPINRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol ForgotMPINRoutingLogic {
    func routeToMPINViewController()
    func routeToOTPController()
}

protocol ForgotMPINDataPassing {
    var dataStore: ForgotMPINDataStore? { get }
}

class ForgotMPINRouter: NSObject, ForgotMPINRoutingLogic, ForgotMPINDataPassing {
    weak var viewController: ForgotMPINViewController?
    var dataStore: ForgotMPINDataStore?
    
    /* Route To MPINViewController */
    func routeToMPINViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.commonMpinViewController) as? CommonMpinViewController, let sourceVC =  viewController {
            
            CommonMpinConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToMPINController(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route To OTPViewController */
    func routeToOTPController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.otpViewController) as? OTPViewController, let sourceVC =  viewController {
            destinationVC.verifyOTPTapped = { (otpString, showSuccessPopUp) in
                self.routeToMPINViewController()
            }
            OTPConfigurator.otpConfigureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToOTPController(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    // MARK: Navigation
    func navigation(source: ForgotMPINViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data to MpinVC
    private func passDataToMPINController(source: ForgotMPINDataStore?, destination: inout CommonMpinDataStore?) {
        destination?.type = .createMpin
        destination?.isFromForgot = true
    }
    
    // MARK: Passing data to OtpVC
    private func passDataToOTPController(source: ForgotMPINDataStore?, destination: inout OTPDataStore?) {
        destination?.number = userMobileNumber
        destination?.isFromForgot = true
    }
}
