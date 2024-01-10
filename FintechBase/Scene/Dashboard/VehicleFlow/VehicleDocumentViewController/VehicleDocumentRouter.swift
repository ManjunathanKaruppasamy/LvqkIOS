//
//  VehicleDocumentRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

@objc protocol VehicleDocumentRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeToFastTagDetailVC()
}

protocol VehicleDocumentDataPassing {
    var dataStore: VehicleDocumentDataStore? { get }
}

class VehicleDocumentRouter: NSObject, VehicleDocumentRoutingLogic, VehicleDocumentDataPassing {
    weak var viewController: VehicleDocumentViewController?
    var dataStore: VehicleDocumentDataStore?
    
    /* Route To VehicleDetailsVC */
    func routeToFastTagDetailVC() {
        if let destinationVC =   UIStoryboard(name: Storyboard.ids.dashboard,
                                              bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.fastTagDetailsViewController) as? FastTagDetailsViewController, let sourceVC =  viewController {
            FastTagDetailsConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    private func navigation(source: VehicleDocumentViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
