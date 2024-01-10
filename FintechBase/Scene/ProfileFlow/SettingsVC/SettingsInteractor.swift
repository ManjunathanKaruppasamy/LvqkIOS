//
//  SettingsInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SettingsBusinessLogic {
    func getUIAttributes()
    func saveToDataStore(value: ProfileItem)
}

protocol SettingsDataStore {
    var routeToEnum: ProfileItem? { get set }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore {
    var presenter: SettingsPresentationLogic?
    var worker: SettingsWorker?
    var routeToEnum: ProfileItem?
    
    // MARK: Save data and connect to presenter
    func saveToDataStore(value: ProfileItem) {
        self.routeToEnum = value
        presenter?.presentContentData()
    }
    
    // MARK: Get User Interface attributes
    func getUIAttributes() {
        let requestDict = [
            "mobile": userMobileNumber
        ]
        worker?.callFetchCustomer(params: requestDict, completion: { responseData, code in
            CORPORATE = responseData?.result?.customerType ?? ""
            DOB = responseData?.result?.dob ?? ""
            EMAIL = responseData?.result?.email ?? ""
            userName = responseData?.result?.name ?? ""
            let name = responseData?.result?.name ?? AppLoacalize.textString.notAvailable
            let emailStr = responseData?.result?.email ?? ""
            let email = emailStr.isEmpty ?  AppLoacalize.textString.notAvailable : emailStr
            let mobile = responseData?.result?.mobile?.description ?? AppLoacalize.textString.notAvailable
            let userData = AccountData(name: name, accountNumber: "123456 78901 123456", upiId: "YAPTAGYESFLEET_2@YESBANKLTD", ifscCode: "YESBOCMSNOCE", mobileNumber: "\(mobile)", email: email)

            let list = [
                SettingsAcccountDetailsData(titleKey: AppLoacalize.textString.accountNumber, valueKey: "QWALLETAG\(mobile)", id: 0),
                SettingsAcccountDetailsData(titleKey: AppLoacalize.textString.ifscCode, valueKey: IFSC, id: 1),
                SettingsAcccountDetailsData(titleKey: AppLoacalize.textString.upiID, valueKey: "QWALLETAG\(mobile)@yesbankltd", id: 2),
                SettingsAcccountDetailsData(titleKey: AppLoacalize.textString.dateOfBirth, valueKey: AppLoacalize.textString.dobMasked, id: 3)
                /*,SettingsAcccountDetailsData(titleKey: AppLoacalize.textString.NETCUPI, valueKey: "netc.\(mobile)@liv", id: 4)*/
            ]

            let response = Settings.Profile.Response.init(profileList: self.loadSettingsList(), userData: userData, userAccountDetailList: list)
            self.presenter?.presentInitialData(response: response)
        })
    }
    
    // MARK: load table data
    private func loadSettingsList() -> [ProfileDetails] {
//        var profileItem = [ProfileItem]()
//        profileItem = [
//            ProfileItem(name: .viewQRCode, flowEnum: .viewQRCode),
//            ProfileItem(name: .manageAccount, flowEnum: .manageAccount),
//            ProfileItem(name: .myMandates, flowEnum: .myMandates),
//            ProfileItem(name: .myBeneficiaries, flowEnum: .myBeneficiaries),
//            ProfileItem(name: .blockedUser, flowEnum: .blockedUser),
//            ProfileItem(name: .viewDispute, flowEnum: .viewDispute)
//        ]
//        profileItem.insert(ProfileItem(name: .createUPIID, flowEnum: .createUPIID), at: 0)
        let settingsList = [
//            ProfileDetails(name: AppLoacalize.textString.manageUPISettings, items: profileItem, images: ""),
            ProfileDetails(name: AppLoacalize.textString.securityAndPrivacySectionTitle, items: [
                ProfileItem(name: .resetandForgetMpin, flowEnum: .resetMpin),
                ProfileItem(name: .biometricLogin, switchEnable: true )
            ], images: ""),
            ProfileDetails(name: AppLoacalize.textString.termsAndPolicySectionTitle, items: [
                ProfileItem(name: .termsandConditions, flowEnum: .termsAndConditions),
//                ProfileItem(name: .kycPolicy, flowEnum: .kycPolicy),
                ProfileItem(name: .privacypolicy, flowEnum: .privacyPolicy),
                ProfileItem(name: .grievancePolicy, flowEnum: .grievancePolicy)
            ], images: ""),
            ProfileDetails(name: AppLoacalize.textString.helpAndSupportSectionTitle, items: [
                ProfileItem(name: .fAQ, flowEnum: .faq),
                ProfileItem(name: .support),
                ProfileItem(name: .trackIssue),
                ProfileItem(name: .accountClosure)
            ], images: "")
        ]
        return settingsList
    }
}
