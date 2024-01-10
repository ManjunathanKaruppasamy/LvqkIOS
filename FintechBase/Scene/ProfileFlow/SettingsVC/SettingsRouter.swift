//
//  SettingsRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol SettingsRoutingLogic {
    func routeToDesiredVC()
    func routeToUpdateEmailFlow()
    func routeToLogoutVC()
    func routeToMPINViewController()
}

protocol SettingsDataPassing {
    var dataStore: SettingsDataStore? { get }
}

class SettingsRouter: NSObject, SettingsRoutingLogic, SettingsDataPassing {
    weak var viewController: SettingsViewController?
    var dataStore: SettingsDataStore?
    private var successFailurePopUpView = SuccessFailurePopUpView()
    private var accountClosurePopUpView = GenericBottomSheetView()
    
    // MARK: Enter MPIN VC
    func routeToMPINViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.commonMpinViewController) as? CommonMpinViewController, let sourceVC =  viewController {
            
            destinationVC.onCompletePin = {
                self.viewController?.delegate?.updatedDOBValue(isShow: true)
            }
            CommonMpinConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToMPINController(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    // MARK: Route to UpdateEmailFlow
    func routeToUpdateEmailFlow() {
        self.routeToUpdateEmailVC()
    }
    
    // MARK: Route to LogoutVC
    func routeToLogoutVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.logoutVC) as? LogoutViewController, let sourceVC = viewController {
            LogoutConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    // MARK: Route to Desired VC
    func routeToDesiredVC() {
        let name = dataStore?.routeToEnum?.name
        switch name {
        case .resetandForgetMpin:
            self.routeToVerifyOtpVC(flowEnum: dataStore?.routeToEnum?.flowEnum ?? .none)
        case .biometricLogin:
            break
        case .termsandConditions, .grievancePolicy, .fAQ, .privacypolicy: // .kycPolicy
            let destinationVC = GenericWebViewController(nibName: Controller.ids.genericWebViewVC, bundle: nil)
            if  let sourceVC = viewController {
                GenericWebConfigurator.configureModule(viewController: destinationVC)
                var destinationDS = destinationVC.router?.dataStore
                passDataToGenericWebVC(sourceDS: dataStore, destinationDS: &destinationDS)
                navigation(source: sourceVC, destination: destinationVC, isPresent: false)
            }
        case .support:
            self.routeToCustomerSupportVC()
        case .trackIssue:
            if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.trackIssueVC) as? TrackIssueViewController, let sourceVC = viewController {
                TrackIssueConfigurator.configureModule(viewController: destinationVC)
                navigation(source: sourceVC, destination: destinationVC, isPresent: false)
            }
        case .accountClosure:
            self.routeToAccountClosureView()
        default:
            break
        }
    }
    
    /* Route To VerifyOtpVc */
    private func routeToVerifyOtpVC(flowEnum: ModuleFlowEnum) {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.otpVerifyVC) as? VerifyOTPViewController, let sourceVC = viewController {
            VerifyOTPConfigurator.configureModule(viewController: destinationVC)
            var destinationDS = destinationVC.router?.dataStore
            passDataToVerifyOtpVC(sourceDS: dataStore, destinationDS: &destinationDS, flowEnum: flowEnum)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    /* Route To CustomerSupportVC */
    private func routeToCustomerSupportVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.cusSupportVC) as? CustomerSupportViewController, let sourceVC = self.viewController {
            CustomerSupportConfigurator.configureModule(viewController: destinationVC)
            var destinationDS = destinationVC.router?.dataStore
            passDataCustomerSupportVC(sourceDS: dataStore, destinationDS: &destinationDS)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    /* Route To UpdateEmailVC */
    private func routeToUpdateEmailVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.updateEmailVC) as? UpdateEmailViewController, let sourceVC = viewController {
            UpdateEmailConfigurator.configureModule(viewController: destinationVC)
            var destinationDS = destinationVC.router?.dataStore
            passDataToUpdateEmailVC(sourceDS: dataStore, destinationDS: &destinationDS, flowEnum: .updateEmail)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    /* Route to account closure custom view */
    private func routeToAccountClosureView() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.accountClosureViewController) as? AccountClosureViewController, let sourceVC = viewController {
            destinationVC.onClickClosureAction = { isClosure in
                if isClosure {
                    self.routeToReasonsForClosureVC()
                    self.viewController?.navigationController?.dismiss(animated: true)
                }
            }
            AccountClosureConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    // MARK: Route to Reaons for account closure VC
    func routeToReasonsForClosureVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.reasonsForClosureViewController) as? ReasonsForClosureViewController, let sourceVC = self.viewController {
            ReasonsForClosureConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    // MARK: Passing Data to Webview
    private func passDataToGenericWebVC(sourceDS: SettingsDataStore?, destinationDS: inout GenericWebDataStore?) {
        destinationDS?.flowEnum = sourceDS?.routeToEnum?.flowEnum ?? .none
        destinationDS?.url = sourceDS?.routeToEnum?.name.url ?? EMPTY
    }
    
    // MARK: Passing Data to Update email flow
    private func passDataToVerifyAadharVC(sourceDS: SettingsDataStore?, destinationDS: inout VerifyAadharDataStore?) {
        destinationDS?.flowEnum = .updateEmail
    }
    
    // MARK: Passing Data to Reset Mpin flow
    private func passDataToVerifyOtpVC(sourceDS: SettingsDataStore?, destinationDS: inout VerifyOTPDataStore?, flowEnum: ModuleFlowEnum) {
        destinationDS?.flowEnum = flowEnum
    }
    
    // MARK: Passing Data to Update Email flow
    private func passDataToUpdateEmailVC(sourceDS: SettingsDataStore?, destinationDS: inout UpdateEmailDataStore?, flowEnum: ModuleFlowEnum) {
        destinationDS?.flowEnum = flowEnum
    }
    
    // MARK: Passing Data Reset Mpin flow
    private func passDataResetMpinVC(sourceDS: SettingsDataStore?, destinationDS: inout ResetMpinDataStore?) {
        destinationDS?.flowEnum = sourceDS?.routeToEnum?.flowEnum ?? .none
    }
    
    // MARK: Passing Data Customer Support
    private func passDataCustomerSupportVC(sourceDS: SettingsDataStore?, destinationDS: inout CustomerSupportDataStore?) {
        destinationDS?.flowEnum = sourceDS?.routeToEnum?.flowEnum ?? .none
    }
    
    // MARK: Navigation
    private func navigation(source: SettingsViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    // MARK: Present Success FailurePopUpView
    private func presentSuccessFailurePopUpView() {
        self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: viewController?.view.frame.width ?? 0, height: viewController?.view.frame.height ?? 0))
        self.successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.thanksForYourInterest, description: AppLoacalize.textString.kycSupportDescription, image: "", isCloseButton: true))
        self.successFailurePopUpView.onClickClose = { value in
            self.successFailurePopUpView.removeFromSuperview()
        }
        viewController?.view.addSubview(successFailurePopUpView)
    }
    // MARK: Passing data
    private func passDataToMPINController(source: SettingsDataStore?, destination: inout CommonMpinDataStore?) {
        destination?.type = .enterMpin
        destination?.isFromDOB = true
    }
}
