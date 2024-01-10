//
//  AddMoneyRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol AddMoneyRoutingLogic {
    func routeToPaymentMethodVC()
    func routeToPayUVC()
    func routeToUPIAppVC()
}

protocol AddMoneyDataPassing {
    var dataStore: AddMoneyDataStore? { get }
}

class AddMoneyRouter: NSObject, AddMoneyRoutingLogic, AddMoneyDataPassing {
  weak var viewController: AddMoneyViewController?
  var dataStore: AddMoneyDataStore?
    private var successFailurePopUpView = SuccessFailurePopUpView()
    
    /* Route To PaymentMethodVC */
    func routeToPaymentMethodVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.paymentMethodViewController) as? PaymentMethodViewController, let sourceVC =  viewController {
            
            PaymentMethodConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToPaymentMethodController(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    /* Route To UPI App VC */
    func routeToUPIAppVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.upiAppsBottomSheetViewController) as? UPIAppsBottomSheetViewController, let sourceVC =  viewController {
            
            UPIAppsBottomSheetConfigurator.configureModule(viewController: destinationVC)
            
            destinationVC.isPaymentSuccess = { isSuccess in
                self.presentSuccessFailurePopUpView(isSuccess: isSuccess)
            }
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToUPIAppVC(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    /* Route To PayUVC */
    func routeToPayUVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.payUViewController) as? PayUViewController, let sourceVC =  viewController {
            
            PayUConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToPayUDataVC(source: dataStore, destination: &destinationDataStore)
            
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
            if isSuccess {
                self.viewController?.navigationController?.popViewController(animated: false)
            }
        }
        self.viewController?.view.addSubview(self.successFailurePopUpView)
    }
    
    // MARK: Navigation
    func navigation(source: AddMoneyViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data to PaymentMethodVC
    private func passDataToPaymentMethodController(source: AddMoneyDataStore?, destination: inout PaymentMethodDataStore?) {
        destination?.amount = viewController?.selectedAmount
    }
    
    /* Pass data to PayUDataVC */
    private func passDataToPayUDataVC(source: AddMoneyDataStore?, destination: inout PayUDataStore?) {
        destination?.loadLink = viewController?.payUResponse?.result ?? ""
    }
    
    private func passDataToUPIAppVC(source: AddMoneyDataStore?, destination: inout UPIAppsBottomSheetDataStore?) {
        destination?.amount = viewController?.selectedAmount
    }
}
