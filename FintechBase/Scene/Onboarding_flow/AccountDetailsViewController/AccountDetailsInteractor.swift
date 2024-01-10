//
//  AccountDetailsInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AccountDetailsBusinessLogic {
    func fetchAccountDetails()
    func fetchOldAccountDetails()
    func callRegisterCustomerAPi(title: String, email: String)
}

protocol AccountDetailsDataStore {
    var isNewUser: Bool? { get set }
    var digiLockerResponse: DigiLockerResponse? { get set }
    var accountDetailsArray: [AccountDetailsData]? { get set }
    var flowEnum: ModuleFlowEnum? { get set }
}

class AccountDetailsInteractor: AccountDetailsBusinessLogic, AccountDetailsDataStore {
    var accountDetailsArray: [AccountDetailsData]?
    var presenter: AccountDetailsPresentationLogic?
    var worker: AccountDetailsWorker?
    var flowEnum: ModuleFlowEnum?
    var digiLockerResponse: DigiLockerResponse?
    var isNewUser: Bool?
    
    func fetchAccountDetails() {
        if self.isNewUser ?? false {
            userName = digiLockerResponse?.kycdetails?.name ?? ""
            self.presenter?.listAccountDetailsDataResponse(data: AccountDetails.FetchList.Response(), flowEnum: self.flowEnum ?? .none, userState: .new)
        } else {
            self.presenter?.listAccountDetailsDataResponse(data: AccountDetails.FetchList.Response(), flowEnum: self.flowEnum ?? .none, userState: .none)
        }
    }
    
    // MARK: Fetch Customer Details
    func fetchOldAccountDetails() {
        let requestDict = [
            "mobile": userMobileNumber
        ]
        
        worker?.callFetchCustomer(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                if response.status == APIStatus.statusString.success {
                    ENTITYID = response.result?.entityid ?? ""
                    CORPORATE =  response.result?.customerType ?? ""
                    DOB = response.result?.dob ?? ""
                    userName = response.result?.name ?? ""
                    let dob = CommonFunctions.convertDateFormate(dateString: response.result?.dob ?? "", outputFormate: .dMMMyyyy)
                    let name = AccountDetailsData(title: AppLoacalize.textString.name, description: response.result?.name?.capitalized)
                    let dateofBirth = AccountDetailsData(title: AppLoacalize.textString.dateOfBirth, description: dob)
                    let mobileNumber = AccountDetailsData(title: AppLoacalize.textString.mobileNumber, description: "\(AppLoacalize.textString.countryCode) \(response.result?.mobile?.description ?? "")")
                    let email = AccountDetailsData(title: AppLoacalize.textString.emailAddress, description: response.result?.email)
                    let address = AccountDetailsData(title: AppLoacalize.textString.address, description: "\(response.result?.address ?? ""),\(response.result?.city ?? ""),\(response.result?.state ?? "") - \(response.result?.pincode?.description ?? "")")
                    
                    if self.flowEnum == .videoKYC {
                        self.accountDetailsArray = [name, mobileNumber, email, address] // dateofBirth
                    } else {
                        self.accountDetailsArray = [name, mobileNumber, email, address] // dateofBirth
                    }
                    
                    let response = AccountDetails.FetchList.Response(accountDetails: self.accountDetailsArray, accountDetailsRespone: response)
                    self.presenter?.listAccountDetailsDataResponse(data: response, flowEnum: self.flowEnum ?? .none, userState: .old)
                } else if response.status == APIStatus.statusString.failed {
                    showSuccessToastMessage(message: response.error ?? AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
                } else {
                    showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
                }
                
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Register Customer API
    func callRegisterCustomerAPi(title: String, email: String) {
        let requestDict = self.getParams(title: title, email: email)
        worker?.callRegisterUSer(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                self.presenter?.customerRegisterResponse(response: AccountDetails.FetchList.Response(registerUserResponseData: response))
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Register Customer API Params
    func getParams(title: String, email: String) -> [String: Any] {
        let digiLocker = self.digiLockerResponse?.kycdetails
        var nameArray = [String]()
        let dob = CommonFunctions.convertDateFormate(dateString: digiLocker?.dob ?? "", inputFormate: .ddmmyyyy, outputFormate: .yyyyMMdd)
        if (digiLocker?.name ?? "").contains(" ") {
            nameArray = digiLocker?.name?.components(separatedBy: " ") ?? []
        } else {
            nameArray = digiLocker?.name?.components(separatedBy: ".") ?? []
        }
        var pincode = ""
        var country = ""
        var state = ""
        var city = ""
        var address1 = ""
        var address2 = ""
        
        var addressArray = digiLocker?.address?.components(separatedBy: ",")
        pincode = addressArray?.last ?? ""
        addressArray?.removeLast()
        country = addressArray?.last ?? ""
        addressArray?.removeLast()
        state = addressArray?.last ?? ""
        addressArray?.removeLast()
        city = addressArray?.last ?? ""
        addressArray?.removeLast()
        address2 = addressArray?.last ?? ""
        addressArray?.removeLast()
        address1 = addressArray?.joined(separator: ",") ?? ""
        
        var requestDict = [
            "title": title,
            "city": city,
            "state": state,
            "country": country,
            "emailAddress": email,
            "address": address1,
            "address2": address2,
            "pincode": pincode,
            "gender": digiLocker?.gender ?? "",
            "dob": dob,
            "proofType": "AADHAARREF",
            "idNumber": digiLocker?.uid ?? "",
            "contactNo": userMobileNumber,
            "entityId": userMobileNumber
        ] as [String: Any]
        
        requestDict.updateValue(nameArray.last ?? "", forKey: "lastName")
        nameArray.removeLast()
        
        requestDict.updateValue(nameArray.joined(separator: " ") ?? "", forKey: "firstName")
    
        return requestDict
    }
}
