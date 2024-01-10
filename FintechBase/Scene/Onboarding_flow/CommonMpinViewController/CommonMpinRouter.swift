//
//  CommonMpinRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

 protocol CommonMpinRoutingLogic {
    func routeToNextVc()
    func routeToBiometricVC(setMPINView: SetMPINView)
    func routeToForgotMPin()
}

protocol CommonMpinDataPassing {
  var dataStore: CommonMpinDataStore? { get }
}

class CommonMpinRouter: NSObject, CommonMpinRoutingLogic, CommonMpinDataPassing {
  weak var viewController: CommonMpinViewController?
  var dataStore: CommonMpinDataStore?
    
    /* Route To NextVC */
    func routeToNextVc() {
        self.viewController?.dismiss(animated: true, completion: {
            self.viewController?.onCompletePin?()
        })
    }
    
    /* Route to biometricVC */
    func routeToBiometricVC(setMPINView: SetMPINView) {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.mpinSuccessViewController) as? MPINSuccessViewController, let sourceVC =  viewController {
            destinationVC.useMPINTapped = {
                    _ = self.viewController?.enterMpinView?.becomeFirstResponder()
            }
            destinationVC.biometricMatched = {
                self.viewController?.interactor?.getMPINLoginResponse(fromBiometric: true, enteredMPIN: "")
            }
            MPINSuccessConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToMPINSuccesController(source: dataStore, destination: &destinationDataStore, setMPINView: setMPINView)
            if setMPINView == .verifyMPIN {
                self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
            } else {
                self.navigation(source: sourceVC, destination: destinationVC)
            }
        }
    }
    
    /* Route To Forgot Mpin */
    func routeToForgotMPin() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.forgotMPINViewController) as? ForgotMPINViewController, let sourceVC =  viewController {
            ForgotMPINConfigurator.configureModule(viewController: destinationVC)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: CommonMpinViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data
      private func passDataToMPINSuccesController(source: CommonMpinDataStore?, destination: inout MPINSuccessDataStore?, setMPINView: SetMPINView) {
          destination?.setMPINView = setMPINView
      }
}
