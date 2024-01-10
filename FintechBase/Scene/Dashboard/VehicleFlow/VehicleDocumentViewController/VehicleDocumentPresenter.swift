//
//  VehicleDocumentPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VehicleDocumentPresentationLogic {
    func presentFieldDetails(documentDetailsField: [DocumentDetailsField], instructionDetailsModel: InstructionDetailsModel?)
    func presentAddVehicleResponse(vehicleResponse: AddVehicleResponce)
}

class VehicleDocumentPresenter: VehicleDocumentPresentationLogic {
   
    weak var viewController: VehicleDocumentDisplayLogic?
    
    // MARK: present Field Details
    func presentFieldDetails(documentDetailsField: [DocumentDetailsField], instructionDetailsModel: InstructionDetailsModel?) {
        self.viewController?.displayFieldDetails(documentDetailsField: documentDetailsField, instructionDetailsModel: instructionDetailsModel)
    }
    
    func presentAddVehicleResponse(vehicleResponse: AddVehicleResponce) {
        viewController?.displayAddVehicleResponse(addVehicleParam: vehicleResponse)
    }
}
