//
//  DashboardWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 08/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class DashboardWorker {
    // MARK: Fetch Wallet Balance
    func callfetchBalanceApi(params: Parameters?, completion: @escaping  (_ results: GetBalanceResponse?,
                                                                          _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.getBalance, parameter: params) { (result: GetBalanceResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Fetch Vehicle List
    func callfetchVehicleListApi(params: Parameters?, completion: @escaping  (_ results: VehicleListResponse?,
                                                                              _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchVehicles, parameter: params) { (result: VehicleListResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Get Card List
    func callGetCardListApi(params: Parameters?, completion: @escaping  (_ results: GetCardResponse?,
                                                                         _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.getCardList, parameter: params) { (result: GetCardResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Get Multi Card List
//    func callGetMultiCardListApi(params: Parameters?, completion: @escaping  (_ results: GetMultiCardResponse?,
//                                                                         _ code: Int?) -> Void) {
//        APIManager.shared().call(type: EndpointItem.fetchAllCards, parameter: params) { (result: GetMultiCardResponse?, error, code, headLessResponse) in
//            if let result = result, code == 200 {
//                completion(result, code)
//            } else {
//                completion(nil, code)
//            }
//        }
//    }
    
    // MARK: Fetch Customer Details
    func callFetchCustomer(params: Parameters?, completion: @escaping (_ results: AccountDetailsRespone?,
                                                                        _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchCustomer, parameter: params) { (result: AccountDetailsRespone?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Get Banner List
    func getBannerList(params: Parameters?, completion: @escaping (_ results: GetBannerApiResponseModel?,
                                                                        _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.getBanners, parameter: params) { (result: GetBannerApiResponseModel?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
