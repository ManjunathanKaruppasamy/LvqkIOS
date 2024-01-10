//
//  DashboardPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 08/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DashboardPresentationLogic {
    func presentwalletBalance(response: Dashboard.DashboardModel.Response)
    func presentGetCardList(response: Dashboard.DashboardModel.Response)
//    func presentGetMultiCardList(response: Dashboard.DashboardModel.Response)
    func presentVehicleListresponse(response: Dashboard.DashboardModel.Response)
    func presentTransactionHistory(data: TransactionHistoryModel?)
    func presentUserData(response: AccountDetailsRespone?)
    func pushToVehicleDetailsVC()
    func pushToTransactionDetailsVc()
    func presentGetBannerListResponse(response: Dashboard.DashboardModel.Response)
    func presentSelectedCardDetails()
}

class DashboardPresenter: DashboardPresentationLogic {
    weak var viewController: DashboardDisplayLogic?
    
    // MARK: Wallet Balance Response
    func presentwalletBalance(response: Dashboard.DashboardModel.Response) {
        let viewModel = Dashboard.DashboardModel.ViewModel(getBalanceViewModel: response.getBalanceResponse)
        viewController?.displayWalletBalanceResponse(viewModel: viewModel)
    }
    
    // MARK: Transaction History Response
    func presentTransactionHistory(data: TransactionHistoryModel?) {
        viewController?.displayTransactionHistory(data: data)
    }
    
    // MARK: Vehicle List Response
    func presentVehicleListresponse(response: Dashboard.DashboardModel.Response) {
        let viewModel = Dashboard.DashboardModel.ViewModel(vehicleListResultArray: response.vehicleListResponse?.result?.result, upiListData: response.upiListData)
        viewController?.displayVehicleListResponse(viewModel: viewModel)
    }
//    // MARK: Get Card List Response
    func presentGetCardList(response: Dashboard.DashboardModel.Response) {
        let viewModel = Dashboard.DashboardModel.ViewModel(getCardViewModel: response.getCardResponse)
        viewController?.displayGetCardListResponse(viewModel: viewModel)
    }
    
    // MARK: Get Multi Card List Response
//    func presentGetMultiCardList(response: Dashboard.DashboardModel.Response) {
//        let viewModel = Dashboard.DashboardModel.ViewModel(getMultiCardResponse: response.getMultiCardResponse)
//        viewController?.displayGetMultiCardListResponse(viewModel: viewModel)
//    }
    
    // MARK: Push To VehicleDetails VC
    func pushToVehicleDetailsVC() {
        self.viewController?.displayVehicleDetails()
    }
    
    /* Present UserData */
    func presentUserData(response: AccountDetailsRespone?) {
        viewController?.displayUserData(response: response)
    }
    
    // MARK: Push To transactionDetails VC
    func pushToTransactionDetailsVc() {
        viewController?.displayTxnExternalID()
    }
    
    /* Present GetBannerList */
    func presentGetBannerListResponse(response: Dashboard.DashboardModel.Response) {
        let viewModel = Dashboard.DashboardModel.ViewModel(getBannerListViewModel: response.getBannerListResponse)
        viewController?.displayGetBannerList(viewModel: viewModel)
    }
    
    /* Present Selected Card details */
    func presentSelectedCardDetails() {
        viewController?.displaySelectedCardDetails()
    }
}
