//
//  VehiclePresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VehiclePresentationLogic {
    func pushToVehicleDetailsVC()
    func presentVehicleListresponse(response: Vehicle.VehicleModel.Response)
    func presentChangeTagStatusResponse(response: Vehicle.VehicleModel.Response )
}

class VehiclePresenter: VehiclePresentationLogic {
    weak var viewController: VehicleDisplayLogic?
    
    // MARK: Push To VehicleDetails VC
    func pushToVehicleDetailsVC() {
        self.viewController?.displayVehicleDetails()
    }
    
    // MARK: Vehicle List Response
    func presentVehicleListresponse(response: Vehicle.VehicleModel.Response) {
        let viewModel = Vehicle.VehicleModel.ViewModel(vehicleListResultArray: response.vehicleListResponse?.result?.result)
        viewController?.displayVehicleListResponse(viewModel: viewModel)
    }
    
    // MARK: Vehicle List Response
    func presentChangeTagStatusResponse(response: Vehicle.VehicleModel.Response) {
        let viewModel = Vehicle.VehicleModel.ViewModel(changeTagStatusResilt: response.changeTagStatusReponse)
        viewController?.displayChangeTagStatusResponse(viewModel: viewModel)
    }
}
