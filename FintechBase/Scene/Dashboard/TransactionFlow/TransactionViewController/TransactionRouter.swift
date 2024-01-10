//
//  TransactionRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation

protocol TransactionRoutingLogic {
    func routeToTransactionDetailsVC()
    func routeToFilterListBottomSheetVC(isDateFilter: Bool)
}

protocol TransactionDataPassing {
    var dataStore: TransactionDataStore? { get }
}

class TransactionRouter: NSObject, TransactionRoutingLogic, TransactionDataPassing {
    weak var viewController: TransactionViewController?
    var dataStore: TransactionDataStore?
    
    // MARK: Route To TransactionDetailsVC
    func routeToTransactionDetailsVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.transactionDetailsViewController) as? TransactionDetailsViewController, let sourceVC =  viewController {
            
            TransactionDetailsConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToTransactionDetailsController(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Route To FilterListBottomSheetVC
    func routeToFilterListBottomSheetVC(isDateFilter: Bool) {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.filterListBottomSheetViewController) as? FilterListBottomSheetViewController, let sourceVC =  viewController {
            
            FilterListBottomSheetConfigurator.configureModule(viewController: destinationVC)
            destinationVC.selectedDate = { (title, index, fromDate, toDate) in
                self.viewController?.selectedDateFilterIndex = index
                self.viewController?.fromDateText = fromDate
                self.viewController?.toDateText = toDate
                self.viewController?.displayDate = title
                self.viewController?.navigationController?.dismiss(animated: true)
            }
            
            destinationVC.selectedFilterByValue = { (title, index) in
                self.viewController?.displayFilterBy = title
                self.viewController?.selectedFilterByIndex = index
                self.viewController?.navigationController?.dismiss(animated: true)
            }
            
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToFilterListBottomSheetController(source: dataStore, destination: &destinationDataStore, isDateFilter: isDateFilter)
            
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    // MARK: Navigation
    func navigation(source: TransactionViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data
    private func passDataToTransactionDetailsController(source: TransactionDataStore?, destination: inout TransactionDetailsDataStore?) {
        destination?.transactionExternalID = source?.transactionExternalID
    }
    
    private func passDataToFilterListBottomSheetController(source: TransactionDataStore?, destination: inout FilterListBottomSheetDataStore?, isDateFilter: Bool) {
        destination?.filterListData = isDateFilter ? source?.dateFilterListData : source?.filterByListData
        destination?.filterState = isDateFilter ? .dateFilter : .normalFilter
        destination?.selectedIndex = isDateFilter ? viewController?.selectedDateFilterIndex : viewController?.selectedFilterByIndex
    }
}
