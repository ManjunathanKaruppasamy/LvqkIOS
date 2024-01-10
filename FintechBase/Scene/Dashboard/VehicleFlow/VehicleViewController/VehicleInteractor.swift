//
//  VehicleInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VehicleBusinessLogic {
    func fetchVehicleList()
    func setDataForVehicleDetailsVC(vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray)
    func fetchChangeTagStatus(kitNo: String, excCode: String, tagOperation: String)
}

protocol VehicleDataStore {
    var vehicleStatus: VehicleStatus? { get set }
    var vehicleListResultArray: VehicleListResultArray? { get set }
}

class VehicleInteractor: VehicleBusinessLogic, VehicleDataStore {
    var presenter: VehiclePresentationLogic?
    var worker: VehicleWorker?
    var vehicleStatus: VehicleStatus?
    var vehicleListResultArray: VehicleListResultArray?
    
    // MARK: Set Data For VehicleDetails VC
    func setDataForVehicleDetailsVC(vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray) {
        self.vehicleStatus = vehicleStatus
        self.vehicleListResultArray = vehicleListResultArray
        self.presenter?.pushToVehicleDetailsVC()
    }
    
    // MARK: Fetch Vehicle List
    func fetchVehicleList() {
        let requestDict = [
            "entityType": entityType,
            "pageSize": "200",
            "pageNumber": "0",
            "parentEntityId": ENTITYID
        ]
        
        worker?.callfetchVehicleListApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let response = Vehicle.VehicleModel.Response(vehicleListResponse: response)
                self.presenter?.presentVehicleListresponse(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Fetch change tag status
    func fetchChangeTagStatus(kitNo: String, excCode: String, tagOperation: String) {
        let requestDict = [
            "kitNo": kitNo,
            "excCode": excCode,
            "tagOperation": tagOperation
        ]
        
        worker?.callChangeTagStatusApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let response = Vehicle.VehicleModel.Response(changeTagStatusReponse: response)
                self.presenter?.presentChangeTagStatusResponse(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
