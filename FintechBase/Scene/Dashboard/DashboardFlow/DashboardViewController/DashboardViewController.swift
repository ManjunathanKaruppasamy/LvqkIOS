//
//  DashboardViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 08/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PCIWidget

protocol DashboardDisplayLogic: AnyObject {
        func displayGetCardListResponse(viewModel: Dashboard.DashboardModel.ViewModel)
//    func displayGetMultiCardListResponse(viewModel: Dashboard.DashboardModel.ViewModel)
    func displayWalletBalanceResponse(viewModel: Dashboard.DashboardModel.ViewModel)
    func displayVehicleListResponse(viewModel: Dashboard.DashboardModel.ViewModel)
    func displayTransactionHistory(data: TransactionHistoryModel?)
    func displayUserData(response: AccountDetailsRespone?)
    func displayVehicleDetails()
    func displayTxnExternalID()
    func displayGetBannerList(viewModel: Dashboard.DashboardModel.ViewModel)
    func displaySelectedCardDetails()
}

class DashboardViewController: UIViewController {
    var interactor: DashboardBusinessLogic?
    var router: (NSObjectProtocol & DashboardRoutingLogic & DashboardDataPassing)?
    
    @IBOutlet weak var slideView: UIView?
    @IBOutlet weak var bgImage: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var dashboardTableview: UITableView?
    
    private var currentSelectedIndex = 0
    private var getBalanceResponse: GetBalanceResponse?
    private var getCardResponse: GetCardResponse?
    private var getCardResultArray: [GetCardResultArray]?
//    private var getMultiCardResponse: GetMultiCardResponse?
//    private var getMultiCardResultArray: [MultiCardResultArray]?
    private var vehicleListResultArray: [VehicleListResultArray]?
    private var transactionHistoryArray = [TransactionHistoryArrayItem]()
    private var getBannerListArray = [GetBannerResult]()
    private var isVehicleApiSuccess: Bool = false
    private var isEmpty: Bool = true
    private var isVkycPending: Bool = false
    private var upiListData: [UPIListData]?
    
    var cardHeight = 100.0
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.interactor?.getUserData()
            self.interactor?.fetchCardList()
//            self.interactor?.fetchMultiCardList()
            self.interactor?.fetchBalance()
            self.interactor?.fetchVehicleList()
            self.interactor?.getBannerList()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let cell = self.dashboardTableview?.cellForRow(at: IndexPath(row: 0, section: 0)) as? CardTableViewCell
        self.cardHeight = Double(slideView?.frame.height ?? 0)
        cell?.cardCellHeight = Double(screenHeight < 750 ? cardHeight : cardHeight - 80)
        cell?.cardCollectionView?.reloadData()
        self.dashboardTableview?.reloadData()
    }
}

// MARK: Initial Set Up
extension DashboardViewController {
    func initialLoads() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setTableView()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.descriptionLabel?.text = AppLoacalize.textString.goodToSeeYou
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .bold, size: .x24)
        descriptionLabel?.font = .setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .white
        descriptionLabel?.textColor = .white
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.dashboardTableview?.register(UINib(nibName: Cell.identifier.cardTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.cardTableViewCell)
        self.dashboardTableview?.register(UINib(nibName: Cell.identifier.bannerTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.bannerTableViewCell)
        self.dashboardTableview?.register(UINib(nibName: Cell.identifier.profileUpdatesTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.profileUpdatesTableViewCell)
        self.dashboardTableview?.register(UINib(nibName: Cell.identifier.vehicleDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.vehicleDetailsTableViewCell)
        self.dashboardTableview?.register(UINib(nibName: Cell.identifier.recentTransactionTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.recentTransactionTableViewCell)
//        self.dashboardTableview?.register(UINib(nibName: Cell.identifier.upiListTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.upiListTableViewCell)
        self.dashboardTableview?.delegate = self
        self.dashboardTableview?.dataSource = self
        self.dashboardTableview?.separatorStyle = .none
    }
}

// MARK: tableView delegate - datasource
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    // swiftlint: disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return self.getCardTableViewCell(indexPath: indexPath)
        case 1:
            return self.getProfileUpdatesTableViewCell(indexPath: indexPath)
//        case 2:
//            return self.getUPIListTableViewCell(indexPath: indexPath)
        case 2:
            return self.getVehicleDetailsTableViewCell(indexPath: indexPath)
        case 3:
            return self.getRecentTransactionTableViewCell(indexPath: indexPath)
        default:
            return self.getBannerTableViewCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        UITableView.automaticDimension
        switch indexPath.row {
        case 0:
            return (screenHeight < 750 ? cardHeight : cardHeight - 80)
        case 1:
            return self.isVkycPending ? 120 : 0
//        case 2:
//            return UITableView.automaticDimension
        case 2:
            return 150
        case 3:
            return self.isEmpty ? 170 : CGFloat(((self.transactionHistoryArray.count * 60) + 70))
        default:
            return self.getBannerListArray.isEmpty ? 30 : 150
        }
    }
    
}
// MARK: Cell for row At
extension DashboardViewController {
    // MARK: CardTableViewCell
    func getCardTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CardTableViewCell = self.dashboardTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.cardTableViewCell, for: indexPath) as? CardTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.walletAmount = (self.getBalanceResponse?.result?.first?.balance ?? AppLoacalize.textString.zeroAmount).getRequiredFractionFormat()
        walletBalance = Double((self.getBalanceResponse?.result?.first?.balance ?? AppLoacalize.textString.zeroAmount).getRequiredFractionFormat()) ?? 0.00
        cell.getCardResultArray = self.getCardResultArray
        cell.cardCollectionView?.reloadData()
        cell.addMoneyTapped = { index in
            if self.getCardResultArray?[indexPath.row].cardStatus?.lowercased() == CardStatus.status.blocked {
                self.router?.presentSuccessFailurePopUpView()
            } else {
                self.interactor?.storeSelectedCardDetails(cardData: self.getCardResultArray?[indexPath.row], balanceDetails: self.getBalanceResponse?.result?[indexPath.row])
            }
        }
        cell.manageCardTapped = { index in
            if self.getCardResultArray?[indexPath.row].cardStatus?.lowercased() == CardStatus.status.blocked {
                self.router?.presentSuccessFailurePopUpView()
            } else {
                let SDKData = SDKModels(getCardResultArray: self.getCardResultArray?[index],
                                        dob: self.getCardResponse?.dob ?? "",
                                        flowType: .card,
                                        presentViewController: self)
                InvokeCardManagementSdk().invokeSDK(data: SDKData, trackIssueHandler: { issueID in
                    self.router?.routeToTrackIssueVC()
                })
            }
        }
        return cell
//        guard let cell: CardTableViewCell = self.dashboardTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.cardTableViewCell, for: indexPath) as? CardTableViewCell else {
//            return UITableViewCell()
//        }
//        cell.selectionStyle = .none
////        let balanceModel = self.getMultiCardResultArray?[indexPath.row].balance?.first
////        walletBalance = Double((balanceModel?.balance ?? AppLoacalize.textString.zeroAmount).getRequiredFractionFormat()) ?? 0.00
//        cell.getMultiCardResultArray = self.getMultiCardResultArray
//        cell.cardCollectionView?.reloadData()
//        cell.addMoneyTapped = { index in
//            if self.getMultiCardResultArray?[index].card?.first?.cardStatus?.lowercased() == CardStatus.status.blocked {
//                self.router?.presentSuccessFailurePopUpView()
//            } else {
//                self.interactor?.storeSelectedCardDetails(cardData: self.getMultiCardResultArray?[index].card?.first, balanceDetails: self.getMultiCardResultArray?[index].balance?.first)
//            }
//        }
//        cell.manageCardTapped = { index in
//            if self.getMultiCardResultArray?[indexPath.row].card?.first?.cardStatus?.lowercased() == CardStatus.status.blocked {
//                self.router?.presentSuccessFailurePopUpView()
//            } else {
//                let SDKData = SDKModels(getMultiCardResultArray: self.getMultiCardResultArray?[index].card?.first,
//                                        dob: DOB,
//                                        flowType: .card,
//                                        presentViewController: self)
//                InvokeCardManagementSdk().invokeSDK(data: SDKData, trackIssueHandler: { issueID in
//                    self.router?.routeToTrackIssueVC()
//                })
//            }
//        }
//        return cell
    }
    
    // MARK: ProfileUpdatesTableViewCell
    func getProfileUpdatesTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ProfileUpdatesTableViewCell = self.dashboardTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.profileUpdatesTableViewCell, for: indexPath) as? ProfileUpdatesTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.bannerCollectionView?.reloadData()
        cell.onClickKYC = {
            self.router?.routeToVideoKycFlow()
        }
        return cell
    }
    
    // MARK: UPI List TableViewCell
    func getUPIListTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UPIListTableViewCell = self.dashboardTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.upiListTableViewCell, for: indexPath) as? UPIListTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setData(upiListData: self.upiListData, upiID: "8946098205.qwallet@liv")
        return cell
    }
    
    // MARK: VehicleDetailsTableViewCell
    func getVehicleDetailsTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell: VehicleDetailsTableViewCell = self.dashboardTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.vehicleDetailsTableViewCell, for: indexPath) as? VehicleDetailsTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if isVehicleApiSuccess {
            cell.vehicleDetailColectionView?.isHidden = false
            if (self.vehicleListResultArray ?? []).isEmpty {
                cell.vehicleDetailColectionView?.isHidden = true
                cell.noVehicleLabel?.isHidden = false
            } else {
                cell.vehicleDetailColectionView?.isHidden = false
                cell.noVehicleLabel?.isHidden = true
                cell.vehicleListResultArray = self.vehicleListResultArray ?? []
                cell.vehicleDetailColectionView?.reloadData()
            }
        } else {
            cell.vehicleDetailColectionView?.isHidden = true
        }
        cell.onClickViewAll = {
            self.tabBarController?.selectedIndex = 1
        }
        cell.onClickVehicleDetails = { index in
            if let vechileArray = self.vehicleListResultArray?[index] {
                self.interactor?.setDataForVehicleDetailsVC(vehicleStatus: CommonFunctions().getVehicleStatus(kitStatus: vechileArray.kitStatus ?? ""), vehicleListResultArray: vechileArray)
            }
        }
//        cell.getItNowTapped = {
//            self.router?.routeToAddVehicleVC()
//        }
        return cell
    }
    
    // MARK: RecentTransactionTableViewCell
    func getRecentTransactionTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RecentTransactionTableViewCell = self.dashboardTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.recentTransactionTableViewCell, for: indexPath) as? RecentTransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.onClickViewAll = {
            self.tabBarController?.selectedIndex = 2
        }
        cell.tapCell = { txnId in
            self.interactor?.getExternalTransactionId(id: txnId)
        }
        cell.updateTransactionHistoryData(data: self.transactionHistoryArray)
        
        return cell
    }
    
    // MARK: BannerTableViewCell
    func getBannerTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell: BannerTableViewCell = self.dashboardTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.bannerTableViewCell, for: indexPath) as? BannerTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.getBannerListArray = self.getBannerListArray
        cell.bannerCollectionView?.reloadData()
        return cell
    }
}

// MARK: Interacter Requests
extension DashboardViewController {
    
    /*  Get TransactionHistory */
    private func getTransactionHistory() {
        let fromDate = self.getStringFromDate(date: Date().getThisMonthStart() ?? Date(), formate: .yyyyMMdd )
        let toDate = self.getStringFromDate(date: Date(), formate: .yyyyMMdd )
        self.interactor?.fetchTransactionHistory(isDateSelected: false, fromDate: fromDate, toDate: toDate)
    }
}

// MARK: Display Logic
extension DashboardViewController: DashboardDisplayLogic {
    /* Display TransactionHistory */
    func displayTransactionHistory(data: TransactionHistoryModel?) {
        guard let responseData = data else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong)
            return
        }
        
        self.transactionHistoryArray = responseData.result ?? [TransactionHistoryArrayItem]()
        self.isEmpty = self.transactionHistoryArray.count == 0 ? true : false
        
        if self.transactionHistoryArray.isEmpty {
            showSuccessToastMessage(message: AppLoacalize.textString.noTransactionAvailable)
        } else {
            self.dashboardTableview?.reloadInMainThread()
        }
    }
    
    /* Wallet Balance Response */
    func displayWalletBalanceResponse(viewModel: Dashboard.DashboardModel.ViewModel) {
        self.getBalanceResponse = viewModel.getBalanceViewModel
        self.dashboardTableview?.reloadInMainThread()
    }
    
    /* Vehicle List Response */
    func displayVehicleListResponse(viewModel: Dashboard.DashboardModel.ViewModel) {
        self.upiListData = viewModel.upiListData
        self.isVehicleApiSuccess = true
        self.vehicleListResultArray = viewModel.vehicleListResultArray
        self.dashboardTableview?.reloadInMainThread()
    }
    
    /* Get Card List Response */
        func displayGetCardListResponse(viewModel: Dashboard.DashboardModel.ViewModel) {
            self.getCardResponse = viewModel.getCardViewModel
            self.getCardResultArray = viewModel.getCardViewModel?.result
            cardDetailsArray = viewModel.getCardViewModel?.result?.first
            self.dashboardTableview?.reloadInMainThread()
        }
    
    /* Get Multi Card List Response */
//    func displayGetMultiCardListResponse(viewModel: Dashboard.DashboardModel.ViewModel) {
//        self.getMultiCardResponse = viewModel.getMultiCardResponse
//        self.getMultiCardResultArray = viewModel.getMultiCardResponse?.result
//        //        cardDetailsArray = viewModel.getCardViewModel?.result?.first
//        self.dashboardTableview?.reloadInMainThread()
//    }
    
    /* Display User data */
    func displayUserData(response: AccountDetailsRespone?) {
        self.getTransactionHistory()
        self.titleLabel?.text = "Hi, \(response?.result?.name?.capitalized ?? AppLoacalize.textString.notAvailable)"
        if response?.result?.kycStatus == "COMPLETED" {
            isMinKYC = false
            isvkycStatusCompleted = true
            self.isVkycPending = false
        } else {
            isvkycStatusCompleted = false
            isMinKYC = true
            self.isVkycPending = true
        }
        self.dashboardTableview?.reloadInMainThread()
    }
    
    /* Display Vehicle details */
    func displayVehicleDetails() {
        self.router?.routeToVehicleDetailsVC()
    }
    
    /* Route To Vechile details */
    func displayTxnExternalID() {
        self.router?.routeToTransactionDetailsVC()
    }
    
    /* Display Banner List */
    func displayGetBannerList(viewModel: Dashboard.DashboardModel.ViewModel) {
        if let list = viewModel.getBannerListViewModel?.result {
            self.getBannerListArray = list
        }
        self.dashboardTableview?.reloadInMainThread()
    }
    
    /* Display Selected Card Details */
    func displaySelectedCardDetails() {
        self.router?.routeToAddMoneyVC()
    }
}
