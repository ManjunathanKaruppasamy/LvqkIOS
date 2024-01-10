//
//  VehicleDetailsInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 15/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

protocol VehicleDetailsBusinessLogic {
    func getVehicleDetails()
    func passVehicleDetails(isDownload: Bool)
    func fetchVehicleTransactionHistory(fromDate: String, toDate: String)
    func getExternalTransactionId(id: String)
}

protocol VehicleDetailsDataStore {
    var vehicleStatus: VehicleStatus? { get set }
    var vehicleListResultArray: VehicleListResultArray? { get set }
    var vehicleNumber: String { get set }
    var url: String { get set }
    var vehicleTransactiondetails: VehicleTransactionArrayItem? { get set }
    var transactionExternalID: String? { get set }
}

class VehicleDetailsInteractor: VehicleDetailsBusinessLogic, VehicleDetailsDataStore {
  
    var presenter: VehicleDetailsPresentationLogic?
    var worker: VehicleDetailsWorker?
    var vehicleListResultArray: VehicleListResultArray?
    var vehicleStatus: VehicleStatus?
    var vehicleNumber: String = ""
    var url: String = ""
    var vehicleTransactiondetails: VehicleTransactionArrayItem?
    var transactionExternalID: String?
    
    // MARK: Get External Transaction id
    func getExternalTransactionId(id: String) {
        self.transactionExternalID = id
        self.presenter?.presentTransactionDetailsVc()
    }
    
    // MARK: Get Vehicle Details
    func getVehicleDetails() {

        let registereddate = CommonFunctions.convertDateFormate(dateString: self.vehicleListResultArray?.registeredDate ?? "", inputFormate: .yyyyMMdd, outputFormate: .dMMMyyyy)
        let vehicleDetails: [VehicleDetailsData] = [VehicleDetailsData(title: AppLoacalize.textString.nameOfTheOwner, description: ((self.vehicleListResultArray?.firstName?.capitalized ?? "")  + " " + (self.vehicleListResultArray?.lastName?.capitalized ?? ""))),
                                                    VehicleDetailsData(title: AppLoacalize.textString.fasTagSerialNumber, description: self.vehicleListResultArray?.serialNo ?? ""),
                                                    VehicleDetailsData(title: AppLoacalize.textString.fasTagRegisteredDate, description: registereddate),
                                                    VehicleDetailsData(title: AppLoacalize.textString.vehicleClass, description: "LMV (VC4)"),
                                                    VehicleDetailsData(title: AppLoacalize.textString.rcRegNo, description: self.vehicleListResultArray?.businessId ?? "")]
        
        let response = VehicleDetails.VehicleDetailsModel.Response(vehicleDetailsArr: vehicleDetails)
        self.presenter?.presentVehicleDetails(response: response, vehicleStatus: self.vehicleStatus ?? .active, vehicleListResultArray: self.vehicleListResultArray)
    }
    
    // MARK: Get Vehicle Details To Next VC
    func passVehicleDetails(isDownload: Bool) {
        if isDownload {
            self.url = "https://www.africau.edu/images/default/sample.pdf"
            self.vehicleNumber = self.vehicleListResultArray?.entityId?.setVehicleFormate() ?? ""
        }
        
        self.presenter?.presentVehicleDetailsToNextVC(isDownload: isDownload)
    }
    
    /* Fetch vehicle transaction history */
    func fetchVehicleTransactionHistory(fromDate: String, toDate: String) {
        let parameters: Parameters = [
                                     "pageNumber": "0",
                                     "pageSize": "5",
                                     "fromDate": fromDate,
                                     "toDate": toDate,
                                     "vehicleId": self.vehicleListResultArray?.entityId ?? ""]
        worker?.callVehicleTransactionApi(params: parameters, completion: { response, code in
            if let responseData = response, code == 200 {
                self.presenter?.presentTransactionHistory(data: responseData)
            } else {
                self.presenter?.presentTransactionHistory(data: response)
            }
        })
    }
    
}
