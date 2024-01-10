//
//  AddVehicleRouter.swift
//  FintechBase
//
//  Created by Sravani Madala on 07/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

@objc protocol AddVehicleRoutingLogic {
    func routeToVehicleVerificationVC()
}

protocol AddVehicleDataPassing {
    var dataStore: AddVehicleDataStore? { get }
}

class AddVehicleRouter: NSObject, AddVehicleRoutingLogic, AddVehicleDataPassing {
    weak var viewController: AddVehicleViewController?
    var dataStore: AddVehicleDataStore?
    
    /* Route to Vehicle Verification flow */
     func routeToVehicleVerificationVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.vehicleDocumentViewController) as? VehicleDocumentViewController, let sourceVC = viewController {
            VehicleDocumentConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    private func navigation(source: AddVehicleViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
