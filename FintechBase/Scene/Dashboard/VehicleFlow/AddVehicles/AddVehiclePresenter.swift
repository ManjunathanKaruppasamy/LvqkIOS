//
//  AddVehiclePresenter.swift
//  FintechBase
//
//  Created by Sravani Madala on 07/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddVehiclePresentationLogic {
    func presentFastTagClassResponse(response: AddVehicle.VehicleFastTagModel.Response)
}

class AddVehiclePresenter: AddVehiclePresentationLogic {
    weak var viewController: AddVehicleDisplayLogic?
    
    // MARK:Present fastTag class response
    func presentFastTagClassResponse(response: AddVehicle.VehicleFastTagModel.Response) {
        let viewModel = AddVehicle.VehicleFastTagModel.ViewModel(getFastTagVehicleModel: response.fastTagVehicleClass)
        viewController?.displayGetFastTagClasses(viewModel: viewModel)
    }
}
