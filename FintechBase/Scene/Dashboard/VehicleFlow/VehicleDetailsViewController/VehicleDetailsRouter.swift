//
//  VehicleDetailsRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 15/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VehicleDetailsRoutingLogic {
    func routeToFitmentCertificateVC()
    func routeToReplaceFasTagVC()
    func routeToNextVc(isFromViewAll: Bool)
    func routeToTransactionDetailsVC()
}

protocol VehicleDetailsDataPassing {
    var dataStore: VehicleDetailsDataStore? { get }
}

class VehicleDetailsRouter: NSObject, VehicleDetailsRoutingLogic, VehicleDetailsDataPassing {
    weak var viewController: VehicleDetailsViewController?
    var dataStore: VehicleDetailsDataStore?
    
    /* Route To NextVC */
    func routeToNextVc(isFromViewAll: Bool) {
        self.viewController?.isViewAllTapped?(isFromViewAll)
    }
    
    // MARK: Route To FitmentCertificateVC
    func routeToFitmentCertificateVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.fitmentCertificateViewController) as? FitmentCertificateViewController, let sourceVC =  viewController {
            
            FitmentCertificateConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToFitmentCertificateVC(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Route To ReplaceFasTagVC
    func routeToReplaceFasTagVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.replaceFasTagViewController) as? ReplaceFasTagViewController, let sourceVC =  viewController {
            
            ReplaceFasTagConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataReplaceTagVC(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route To TransactionDetailsVC */
    func routeToTransactionDetailsVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.transactionDetailsViewController) as? TransactionDetailsViewController, let sourceVC =  viewController {
            
            TransactionDetailsConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataTransactionDetailsVC(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: VehicleDetailsViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data to FitmentCertificateVC
    private func passDataToFitmentCertificateVC(source: VehicleDetailsDataStore?, destination: inout FitmentCertificateDataStore?) {
        destination?.fitmentCertificateData = FitmentCertificateData(vehicleNumber: source?.vehicleNumber ?? "", url: source?.url ?? "")
    }
    
    // MARK: Passing data to TransactionDetailsVC
    private func passDataTransactionDetailsVC(source: VehicleDetailsDataStore?, destination: inout TransactionDetailsDataStore?) {
        destination?.transactionExternalID = source?.transactionExternalID
    }
    
    // MARK: Passing data to ReplaceTagVC
    private func passDataReplaceTagVC(source: VehicleDetailsDataStore?, destination: inout ReplaceFasTagDataStore?) {
        destination?.vehileNumber = source?.vehicleListResultArray?.entityId?.setVehicleFormate() ?? ""
    }
    
}
