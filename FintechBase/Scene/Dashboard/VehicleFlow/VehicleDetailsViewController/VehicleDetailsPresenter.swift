//
//  VehicleDetailsPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 15/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VehicleDetailsPresentationLogic {
    func presentVehicleDetails(response: VehicleDetails.VehicleDetailsModel.Response, vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray?)
    func presentVehicleDetailsToNextVC(isDownload: Bool)
    func presentTransactionHistory(data: VehicleTransactionModel?)
    func presentTransactionDetailsVc()
}

class VehicleDetailsPresenter: VehicleDetailsPresentationLogic {
    weak var viewController: VehicleDetailsDisplayLogic?
    
    // MARK: Present Vehicle Details
    func presentVehicleDetails(response: VehicleDetails.VehicleDetailsModel.Response, vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray?) {
        let viewModel = VehicleDetails.VehicleDetailsModel.ViewModel(vehicleDetailsDataArr: response.vehicleDetailsArr)
        viewController?.displayVehicleDetails(viewModel: viewModel, vehicleStatus: vehicleStatus, vehicleListResultArray: vehicleListResultArray)
    }
    // MARK: Present Vehicle Details To Next VC
    func presentVehicleDetailsToNextVC(isDownload: Bool) {
        self.viewController?.displayVehicleDetailsToNextVC(isDownload: isDownload)
    }
    
    /* Present Vehicle TransactionHistory */
    func presentTransactionHistory(data: VehicleTransactionModel?) {
        viewController?.displayTransactionHistory(data: data)
    }
    
    // MARK: Push To transactionDetails VC
    func presentTransactionDetailsVc() {
        viewController?.displayTxnExternalID()
    }
}
