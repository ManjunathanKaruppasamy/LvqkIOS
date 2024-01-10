//
//  FastTagDetailsPresenter.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FastTagDetailsPresentationLogic {
    func presentPayuResponse(paymentParam: PayUResponse)
    func presentFastTagFeeResponse(response: FastTagDetails.FastTagFeeModel.Response)
    func presentAddVehicleResponse(vehicleResponse: AddVehicleResponce)
}

class FastTagDetailsPresenter: FastTagDetailsPresentationLogic {

    weak var viewController: FastTagDetailsDisplayLogic?
    
    // MARK: Present fastTag class response
    func presentFastTagFeeResponse(response: FastTagDetails.FastTagFeeModel.Response) {
        let viewModel = FastTagDetails.FastTagFeeModel.ViewModel(getfastTagFeeModel: response.fastTagFee)
        viewController?.displayGetFastTagFeeData(viewModel: viewModel)
    }
    
    // MARK: Present PayU
    func presentPayuResponse(paymentParam: PayUResponse) {
        viewController?.displayPayUResponse(paymentParam: paymentParam)
    }
    
    // MARK: Add Vehicle
    func presentAddVehicleResponse(vehicleResponse: AddVehicleResponce) {
        viewController?.displayAddVehicleResponse(addVehicleParam: vehicleResponse)
    }
}
