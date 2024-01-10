//
//  MobileNumberInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

protocol MobileNumberBusinessLogic {
    func mobileNumberData(number: String)
    func setDigiLockerResponse(digiLockerResponse: DigiLockerResponse?)
}

protocol MobileNumberDataStore {
    var number: String? { get set }
    var digiLockerResponse: DigiLockerResponse? { get set }
}

class MobileNumberInteractor: MobileNumberBusinessLogic, MobileNumberDataStore {
    var presenter: MobileNumberPresentationLogic?
    var worker: MobileNumberWorker?
    var number: String?
    var digiLockerResponse: DigiLockerResponse?
    
    // MARK: Get Mobile Number Data
    func mobileNumberData(number: String) {
        self.number = number
        let requestDict = [
            "mobile": number,
            "appGuid": DEVICEID,
            "version": APPVERSION,
            "platform": PLATFORM
        ]
        worker?.callRegisterCustomer(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let customerResponse = MobileNumberModel.Customer.Response(response: response)
                self.presenter?.presentMobileNumberKitsList(response: customerResponse)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: set Digi Locker Response
    func setDigiLockerResponse(digiLockerResponse: DigiLockerResponse?) {
        self.digiLockerResponse = digiLockerResponse
        self.presenter?.presentDigiLockerResponse()
        
    }
}
