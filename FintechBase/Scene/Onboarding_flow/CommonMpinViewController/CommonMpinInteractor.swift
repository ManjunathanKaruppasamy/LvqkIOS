//
//  CommonMpinInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
import UIKit
@_implementationOnly import Alamofire

protocol CommonMpinBusinessLogic {
    func getMPINLoginResponse(fromBiometric: Bool, enteredMPIN: String)
    func getUpdateCustomerApi(mpin: String)
    func getInitialSetUpData()
    func getValidateCreatePin(createMpinString: String, confirmMpinString: String)
    func startMpinTimer()
    func stopMpinTimer()
    func getUserData()
    func getCommonMpinData(request: CommonMpin.CommonMpinModels.Request)
    func getValidateEmptyField(validateString: String)
    func getValidateCreateConfirm(createMpinString: String, confirmMpinString: String)
}

protocol CommonMpinDataStore {
    var type: MpinType? { get set }
    var isFromForgot: Bool? { get set }
    var isFromDOB: Bool? { get set }
}

class CommonMpinInteractor: CommonMpinBusinessLogic, CommonMpinDataStore {
    var type: MpinType?
    var isFromForgot: Bool?
    var isFromDOB: Bool?
    var presenter: CommonMpinPresentationLogic?
    var worker: CommonMpinWorker?
    
    // MARK: Get Initial SetUp Data
    func getInitialSetUpData() {
        var mpinInitialData: MpinInitialData = MpinInitialData(type: self.type ?? .changeMpin, isFromForgot: self.isFromForgot ?? false, isFromDOB: self.isFromDOB ?? false)
        self.presenter?.sendInitialSetUpData(mpinInitialData: mpinInitialData)
        
    }
    
    // MARK: Start Timer
    func startMpinTimer() {
        worker?.callTimer(countDownVal: 60, completion: { updateCountDown in
            self.presenter?.updateCount(totalTime: updateCountDown)
        })
    }
    
    // MARK: Stop Timer
    func stopMpinTimer() {
        worker?.endTimer()
    }
    // MARK: Validate Enter MPIN Empty Data
    func getValidateEmptyField(validateString: String) {
        if validateString.contains("$") {
            self.presenter?.sendValidateEmptyField(isEmpty: true)
        } else {
            self.presenter?.sendValidateEmptyField(isEmpty: false)
        }
    }
    // MARK: Validate Enter MPIN Data
    func getCommonMpinData(request: CommonMpin.CommonMpinModels.Request) {
        if request.enteredMpin == MPIN {
            presenter?.commonMpinPresentData(isSuccess: true, enteredPin: request.enteredMpin ?? "")
        } else {
            presenter?.commonMpinPresentData(isSuccess: false, enteredPin: request.enteredMpin ?? "")
        }
    }
    
    // MARK: Validate Create MPIN Data
    func getValidateCreatePin(createMpinString: String, confirmMpinString: String) {
        if createMpinString.contains("$") {
            presenter?.sendCreatConfirmEmptyField(isEmpty: true, field: createMpinString)
        } else if confirmMpinString.contains("$") {
            presenter?.sendCreatConfirmEmptyField(isEmpty: true, field: confirmMpinString)
        } else {
            if createMpinString == confirmMpinString {
                presenter?.sendCreatConfirmMatchData(isMatch: true)
            } else {
                presenter?.sendCreatConfirmMatchData(isMatch: false)
            }
//            presenter?.sendCreatConfirmEmptyField(isEmpty: false, field: createMpinString)
        }
        
    }
    
    // MARK: Validate Create/Confirm MPIN Data
    func getValidateCreateConfirm(createMpinString: String, confirmMpinString: String) {
        if createMpinString.contains("$") {
            presenter?.sendCreatConfirmMatchData(isMatch: false)
//            presenter?.sendCreatConfirmEmptyField(isEmpty: true, field: createMpinString)
        } else if confirmMpinString.contains("$") {
            presenter?.sendCreatConfirmMatchData(isMatch: false)
//            presenter?.sendCreatConfirmEmptyField(isEmpty: true, field: confirmMpinString)
        } else {
            if createMpinString == confirmMpinString {
                presenter?.sendCreatConfirmMatchData(isMatch: true)
            } else {
                presenter?.sendCreatConfirmMatchData(isMatch: false)
            }
//            presenter?.sendCreatConfirmEmptyField(isEmpty: false, field: "")
        }
    }
    
    // MARK: Get Update Customer API
    func getUpdateCustomerApi(mpin: String) {
        let keyValueDict: Parameters = [
          "mpin": mpin
        ]
        
        let requestDict: Parameters = [
            "mobile": userMobileNumber ,
          "keyValue": keyValueDict
        ]
        
        worker?.callMPINApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let response = CommonMpin.CommonMpinModels.Response(mpinResponseData: response)
                self.presenter?.presentMPINResponse(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Get MPIN Login Response
    func getMPINLoginResponse(fromBiometric: Bool, enteredMPIN: String) {
        let requestDict = [
            "mobile": userMobileNumber ,
            "mpin": fromBiometric ? (MPIN ) : (enteredMPIN)
        ]
        
        worker?.callLoginMPIN(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                ACCESSTOKEN = response.accessToken ?? ""
                REFRESHTOKEN = response.refreshToken ?? ""
                let response = CommonMpin.CommonMpinModels.Response(loginMpinResponseData: response)
                self.presenter?.presentLoginMpinResponse(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
        
    }
    
    func getUserData() {
       let requestDict = [
        "mobile": userMobileNumber
          ]
        worker?.callFetchCustomer(params: requestDict, completion: { response, code in
            if let responseData = response, code == 200 {
                ENTITYID = responseData.result?.entityid ?? ""
                CORPORATE = responseData.result?.customerType ?? ""
                DOB = responseData.result?.dob ?? ""
                userName = responseData.result?.name ?? ""
                EMAIL = responseData.result?.email ?? ""
                self.presenter?.presentUserData(response: responseData)
            } else {
                self.presenter?.presentUserData(response: response)
            }
        })
    }
    
}
