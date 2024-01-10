//
//  AddVehicleInteractor.swift
//  FintechBase
//
//  Created by Sravani Madala on 07/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddVehicleBusinessLogic {
    func getVehicleClassesData()
}

protocol AddVehicleDataStore {
    // var name: String { get set }
}

class AddVehicleInteractor: AddVehicleBusinessLogic, AddVehicleDataStore {
    var presenter: AddVehiclePresentationLogic?
    var worker: AddVehicleWorker?

    // MARK: get Vehicle Fast Tag Response
    func getVehicleClassesData() {
        worker?.fetchVehicleClassesList(params: [:], completion: { results, code in
            if let response = results, code == 200 {
                let response = AddVehicle.VehicleFastTagModel.Response(fastTagVehicleClass: response)
                self.presenter?.presentFastTagClassResponse(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
