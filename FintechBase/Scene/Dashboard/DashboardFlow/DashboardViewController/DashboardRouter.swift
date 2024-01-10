//
//  DashboardRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 08/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DashboardRoutingLogic {
    func routeToAddMoneyVC()
    func routeToVideoKycFlow()
    func routeToTransactionDetailsVC()
    func routeToVehicleDetailsVC()
    func routeToTrackIssueVC()
    func routeToAddVehicleVC()
    func presentSuccessFailurePopUpView()
}

protocol DashboardDataPassing {
    var dataStore: DashboardDataStore? { get }
}

class DashboardRouter: NSObject, DashboardRoutingLogic, DashboardDataPassing {
    weak var viewController: DashboardViewController?
    var dataStore: DashboardDataStore?
    private var successFailurePopUpView = SuccessFailurePopUpView()
    
    /* Route To VideoKycFlow */
    func routeToVideoKycFlow() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.accountDetailsViewController) as? AccountDetailsViewController, let sourceVC =  viewController {
            AccountDetailsConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToAccountDetailsVC(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route To AddMoneyVC */
    func routeToAddMoneyVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.addMoneyViewController) as? AddMoneyViewController, let sourceVC =  viewController {
            
            AddMoneyConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToAddMoneyVC(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route To TransactionDetailsVC */
    func routeToTransactionDetailsVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.transactionDetailsViewController) as? TransactionDetailsViewController, let sourceVC =  viewController {
            
            TransactionDetailsConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToTransactionDetailsVC(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route to VehicleDetailsVC */
    func routeToVehicleDetailsVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.vehicleDetailsViewController) as? VehicleDetailsViewController, let sourceVC =  viewController {
            destinationVC.isViewAllTapped = { isFromViewAll in
                self.viewController?.tabBarController?.selectedIndex = isFromViewAll ? 2 : 0
                self.viewController?.navigationController?.popViewController(animated: !isFromViewAll)
            }
            
            VehicleDetailsConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToVehicleDetailsdController(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Present Success FailurePopUpView
        func presentSuccessFailurePopUpView() {
            self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: viewController?.view.frame.width ?? 0, height: viewController?.view.frame.height ?? 0))
            successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.cardBlocked, description: AppLoacalize.textString.cardBlockDescription, image: Image.imageString.cardBlocked, primaryButtonTitle: AppLoacalize.textString.okText, isCloseButton: false))
            self.successFailurePopUpView.onClickClose = { value in
                self.successFailurePopUpView.removeFromSuperview()
            }
            viewController?.view.addSubview(successFailurePopUpView)
        }
   
    /* Route To TrackIssueVC */
    func routeToTrackIssueVC() {
        if let destinationVC =  UIStoryboard(name: Storyboard.ids.profile,
                                             bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.trackIssueVC) as? TrackIssueViewController, let sourceVC = viewController {
            TrackIssueConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    /* Route To VehicleDetailsVC */
    func routeToAddVehicleVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.addVehicleViewController) as? AddVehicleViewController, let sourceVC =  viewController {
            AddVehicleConfigurator.configureModule(viewController: destinationVC)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: DashboardViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data to AccountDetailsVC
    private func passDataToAccountDetailsVC(source: DashboardDataStore?, destination: inout AccountDetailsDataStore?) {
        destination?.flowEnum = .videoKYC
    }
    
    // MARK: Passing data to TransactionDetailsVC
    private func passDataToTransactionDetailsVC(source: DashboardDataStore?, destination: inout TransactionDetailsDataStore?) {
        destination?.transactionExternalID = source?.transactionExternalID
    }
    
    // MARK: Passing data to VehicleDetailsVC
    private func passDataToVehicleDetailsdController(source: DashboardDataStore?, destination: inout VehicleDetailsDataStore?) {
        destination?.vehicleStatus = source?.vehicleStatus
        destination?.vehicleListResultArray = source?.vehicleListResultArray
    }
    
    // MARK: Pass data to AddMoneyVC 
    private func passDataToAddMoneyVC(source: DashboardDataStore?, destination: inout AddMoneyDataStore?) {
        destination?.selectedCardResult = source?.selectedCardDetails
        destination?.selectedCardBalance = source?.selectedCardBalance
    }
    
}
