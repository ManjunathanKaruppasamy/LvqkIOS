//
//  NegativeBalanceRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol NegativeBalanceRoutingLogic {
    func routeToUPIAppVC()
    func routeToPayUVC()
    func routeToOTPController()
}

protocol NegativeBalanceDataPassing {
    var dataStore: NegativeBalanceDataStore? { get }
}

class NegativeBalanceRouter: NSObject, NegativeBalanceRoutingLogic, NegativeBalanceDataPassing {
    weak var viewController: NegativeBalanceViewController?
    var dataStore: NegativeBalanceDataStore?
    private var successFailurePopUpView = SuccessFailurePopUpView()
    
    /* Route To UPI App VC */
    func routeToUPIAppVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.upiAppsBottomSheetViewController) as? UPIAppsBottomSheetViewController, let sourceVC =  viewController {
            destinationVC.isPaymentSuccess = { isSuccess in
                self.presentSuccessFailurePopUpView(isSuccess: isSuccess)
            }
            
            UPIAppsBottomSheetConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToUPIAppVC(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    // MARK: Present Success FailurePopUpView
    func presentSuccessFailurePopUpView(isSuccess: Bool) {
        self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: self.viewController?.view.frame.width ?? 0, height: self.viewController?.view.frame.height ?? 0))
        if isSuccess {
            successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.paymentSuccess, description: AppLoacalize.textString.paymentSuccessDescription, image: Image.imageString.successTick, primaryButtonTitle: AppLoacalize.textString.okText))
        } else {
            successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.paymentFailure, description: AppLoacalize.textString.paymentFailureDesription, image: Image.imageString.failureClose, primaryButtonTitle: AppLoacalize.textString.tryOtherPaymentOption))
        }
        self.successFailurePopUpView.onClickClose = { value in
            self.successFailurePopUpView.removeFromSuperview()
            self.viewController?.fetchBalance()
        }
        self.viewController?.view.addSubview(self.successFailurePopUpView)
    }
    
    /* Route To PayUVC */
    func routeToPayUVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.payUViewController) as? PayUViewController, let sourceVC =  viewController {
            
            PayUConfigurator.configureModule(viewController: destinationVC)
            destinationVC.payUStatus = { isSuccess in
                self.viewController?.fetchBalance()
            }
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToPayUDataVC(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Route To OTPViewController */
    func routeToOTPController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.otpViewController) as? OTPViewController, let sourceVC =  viewController {
            destinationVC.verifyOTPTapped = { (otpString, showSuccessPopUp) in
                self.routeToVerficationViewController()
            }
            OTPConfigurator.otpConfigureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToOTPController(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Route To VerficationViewController */
    func routeToVerficationViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.accountClosureStoryBoard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.verficationViewController) as? VerficationViewController, let sourceVC =  viewController {
            
            VerficationConfigurator.configureModule(viewController: destinationVC)
            destinationVC.isApiSuccess = { (isSuccess, message) in
                if isSuccess {
                    self.routeToRequestSubmittedViewController(accountCloseScreen: .submitted)
                } else {
                    self.routeToRequestSubmittedViewController(accountCloseScreen: .inProgress)
                }
            }
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToVerficationController(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Route To RequestSubmittedViewController */
    func routeToRequestSubmittedViewController(accountCloseScreen: AccountCloseScreen) {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.accountClosureStoryBoard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.requestSubmittedViewController) as? RequestSubmittedViewController, let sourceVC =  viewController {
            
            RequestSubmittedConfigurator.configureModule(viewController: destinationVC)
            
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToRequestSubmittedVC(source: dataStore, destination: &destinationDataStore, accountCloseScreen: accountCloseScreen)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Pass data to PayUDataVC */
    private func passDataToPayUDataVC(source: NegativeBalanceDataStore?, destination: inout PayUDataStore?) {
        destination?.loadLink = viewController?.payUResponse?.result ?? ""
        destination?.isAccountClose = true
    }
    
    // MARK: Passing data to OtpVC
    private func passDataToOTPController(source: NegativeBalanceDataStore?, destination: inout OTPDataStore?) {
        destination?.number = userMobileNumber
        destination?.isFromAccountClose = true
    }
    // MARK: Passing data to RequestSubmittedViewController
    private func passDataToRequestSubmittedVC(source: NegativeBalanceDataStore?, destination: inout RequestSubmittedDataStore?, accountCloseScreen: AccountCloseScreen) {
        destination?.accountCloseScreen = accountCloseScreen
    }
    
    // MARK: Passing data to VerficationViewController
    private func passDataToVerficationController(source: NegativeBalanceDataStore?, destination: inout VerficationDataStore?) {
        destination?.flowFromVC = .accountClosure
    }
    
    // MARK: Passing data to UPIAppVC
    private func passDataToUPIAppVC(source: NegativeBalanceDataStore?, destination: inout UPIAppsBottomSheetDataStore?) {
        destination?.amount = viewController?.selectedAmount.replace(string: "-", replacement: "")
    }
    
    // MARK: Navigation
    func navigation(source: NegativeBalanceViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
}
