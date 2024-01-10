//
//  SettingsModels.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation

enum Settings {
  // MARK: Use cases
  
  enum Profile {
    struct Request {
    }
    struct Response {
        var profileList: [ProfileDetails]
        var userData: AccountData?
        var userAccountDetailList: [SettingsAcccountDetailsData]
    }
    struct ViewModel {
        var profileList: [ProfileDetails]
        var userData: AccountData?
        var userAccountDetailList: [SettingsAcccountDetailsData]
    }
  }
}

// MARK: Account data
struct AccountData {
    var name: String
    var accountNumber: String
    var upiId: String
    var ifscCode: String
    var mobileNumber: String
    var email: String
    
    init(name: String, accountNumber: String, upiId: String, ifscCode: String, mobileNumber: String, email: String) {
        self.name = name
        self.accountNumber = accountNumber
        self.upiId = upiId
        self.ifscCode = ifscCode
        self.mobileNumber = mobileNumber
        self.email = email
    }
}

// MARK: Profile Model
struct ProfileDetails {
    var name: String
    var items: [ProfileItem]
    var images: String
    
    init(name: String, items: [ProfileItem], images: String) {
        self.name = name
        self.items = items
        self.images = images
    }
}

struct ProfileItem {
    var name: ProfileListEnum
    var value: String
    var status: String
    var switchEnable: Bool
    var flowEnum: ModuleFlowEnum

    init(name: ProfileListEnum, value: String = "", status: String = "", switchEnable: Bool = false, flowEnum: ModuleFlowEnum = .none) {
        self.name = name
        self.value = value
        self.status = status
        self.switchEnable = switchEnable
        self.flowEnum = flowEnum
    }
}

// MARK: Settings Acccount Details Data
struct SettingsAcccountDetailsData {
    var titleKey: String
    var valueKey: String
    var status: Bool
    var id: Int
    
    init(titleKey: String, valueKey: String, status: Bool = false, id: Int) {
        self.titleKey = titleKey
        self.valueKey = valueKey
        self.status = status
        self.id = id
    }
}

enum ProfileListEnum: String, CustomStringConvertible {
    case resetandForgetMpin
    case biometricLogin
    case termsandConditions
//    case kycPolicy
    case privacypolicy
    case grievancePolicy
    case fAQ
    case support
    case trackIssue
    case accountClosure
    case createUPIID
    case viewQRCode
    case manageAccount
    case myMandates
    case myBeneficiaries
    case blockedUser
    case viewDispute
    
    var description: String {
        switch self {
        case .resetandForgetMpin: return AppLoacalize.textString.resetandForgetMpinRowTitle
        case .biometricLogin: return AppLoacalize.textString.biometricLoginRowTitle
        case .termsandConditions: return AppLoacalize.textString.termsandConditionRowTitle
//        case .kycPolicy: return AppLoacalize.textString.kycPolicyRowTitle
        case .privacypolicy: return AppLoacalize.textString.privacyPolicyRowTitle
        case .grievancePolicy: return AppLoacalize.textString.grievancePolicyRowTitle
        case .fAQ: return AppLoacalize.textString.fAQRowTitle
        case .support: return AppLoacalize.textString.supportRowTitle
        case .trackIssue: return AppLoacalize.textString.trackIssueRowTitle
        case .accountClosure: return AppLoacalize.textString.accountClosureRowTitle
        case .createUPIID: return AppLoacalize.textString.createUPIID
        case .viewQRCode: return AppLoacalize.textString.viewQRCode
        case .manageAccount: return AppLoacalize.textString.manageAccount
        case .myMandates: return AppLoacalize.textString.myMandates
        case .myBeneficiaries: return AppLoacalize.textString.myBeneficiaries
        case .blockedUser: return AppLoacalize.textString.blockedUser
        case .viewDispute: return AppLoacalize.textString.viewDispute
        }
    }
    
    var url: String {
        switch self {
        case .resetandForgetMpin:
            return EMPTY
        case .biometricLogin:
            return EMPTY
        case .termsandConditions:
            return WebViewUrl.urlString.termsAndConditions
//        case .kycPolicy:
//            return WebViewUrl.urlString.disputePolicy
        case .privacypolicy:
            return WebViewUrl.urlString.privacyPolicy
        case .grievancePolicy:
            return WebViewUrl.urlString.greivancePolicy
        case .fAQ:
            return WebViewUrl.urlString.faq
        case .support:
            return EMPTY
        case .trackIssue:
            return EMPTY
        case .accountClosure:
            return EMPTY
        default:
            return EMPTY
        }
    }
}

struct OnCopyData {
    var title: String?
    var copiedString: String?
    var id: Int?
    var isShowDOB: Bool
}
