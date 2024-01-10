//
//  VehicleDetailsViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 15/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VehicleDetailsDisplayLogic: AnyObject {
    func displayVehicleDetails(viewModel: VehicleDetails.VehicleDetailsModel.ViewModel, vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray?)
    func displayVehicleDetailsToNextVC(isDownload: Bool)
    func displayTransactionHistory(data: VehicleTransactionModel?)
    func displayTxnExternalID()
}

class VehicleDetailsViewController: UIViewController {
    var interactor: VehicleDetailsBusinessLogic?
    var router: (NSObjectProtocol & VehicleDetailsRoutingLogic & VehicleDetailsDataPassing)?
    
    @IBOutlet weak var navView: UIView?
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var navTitle: UILabel?
    @IBOutlet weak var mainView: UIView?
    
    @IBOutlet weak var vehicleNumberStatusView: UIView?
    @IBOutlet weak var vehicleNumberLabel: UILabel?
    @IBOutlet weak var statusView: UIView?
    @IBOutlet weak var statusSwitch: UISwitch?
    @IBOutlet weak var statusLabel: UILabel?
    
    @IBOutlet weak var vehicleDetailsTableView: UITableView?
    @IBOutlet weak var downloadFitmentLabel: UILabel?
    @IBOutlet weak var replaceFastTagLabel: UILabel?
    
    @IBOutlet weak var recentTransactionView: UIView?
    @IBOutlet weak var recentTransactionTitleLabel: UILabel?
    @IBOutlet weak var viewAllButton: UIButton?
    @IBOutlet weak var recentTransactionTableView: UITableView?
    
    @IBOutlet weak var vehicleDetailsTableViewHeight: NSLayoutConstraint?
    @IBOutlet weak var recentTransactionTableViewHeight: NSLayoutConstraint?
    @IBOutlet weak var noTransactionAvailableLabel: UILabel?
    
    var vehicleDetailsArr: [VehicleDetailsData] = [VehicleDetailsData]()
    var vehicleListResultArray: VehicleListResultArray?
    private var transactionHistoryArray = [VehicleTransactionArrayItem]()
    var isViewAllTapped: ((Bool) -> Void)?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.mainView?.layer.cornerRadius = 16
        self.navView?.applyGradient(isVertical: true, colorArray: [.appDarkPinkColor, .appDarkBlueColor])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTransactionHisory()
    }
    
}

// MARK: Initial Set Up
extension VehicleDetailsViewController {
    func initialLoads() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setTableView()
        self.setAction()
        self.navigationController?.isNavigationBarHidden = true
        self.interactor?.getVehicleDetails()
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.navTitle?.text = AppLoacalize.textString.viewDetailsTitle
        self.downloadFitmentLabel?.text = AppLoacalize.textString.downloadTagFitment
        self.replaceFastTagLabel?.text = AppLoacalize.textString.replaceFasTag
        self.recentTransactionTitleLabel?.text = AppLoacalize.textString.recentTransactions
        
        let font = UIFont.setCustomFont(name: .regular, size: .x12)
        let downloadFitmentLabelString = NSMutableAttributedString(string: AppLoacalize.textString.downloadTagFitment)
        downloadFitmentLabelString.apply(color: UIColor.blusihGryColor, subString: AppLoacalize.textString.downloadTagFitment, textFont: font)
        self.downloadFitmentLabel?.attributedText = downloadFitmentLabelString
        
        let downloadFitmentLabelAttributedString = NSMutableAttributedString(string: AppLoacalize.textString.downloadTagFitment)
        downloadFitmentLabelAttributedString.applyUnderLineText(subString: AppLoacalize.textString.downloadTagFitment, textFont: font)
        self.downloadFitmentLabel?.attributedText = downloadFitmentLabelAttributedString
        
        let replaceFastTagLabelString = NSMutableAttributedString(string: AppLoacalize.textString.replaceFasTag)
        replaceFastTagLabelString.apply(color: UIColor.blusihGryColor, subString: AppLoacalize.textString.replaceFasTag, textFont: font)
        self.replaceFastTagLabel?.attributedText = replaceFastTagLabelString
        
        let replaceFastTagLabelAttributedString = NSMutableAttributedString(string: AppLoacalize.textString.replaceFasTag)
        replaceFastTagLabelAttributedString.applyUnderLineText(subString: AppLoacalize.textString.replaceFasTag, textFont: font)
        self.replaceFastTagLabel?.attributedText = replaceFastTagLabelAttributedString
        self.noTransactionAvailableLabel?.isHidden = true
    }
    
    // MARK: Font
    private func setFont() {
        self.navTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.vehicleNumberLabel?.font = .setCustomFont(name: .regular, size: .x18)
        self.statusLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.downloadFitmentLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.replaceFastTagLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.recentTransactionTitleLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        self.noTransactionAvailableLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
    }
    
    // MARK: Color
    private func setColor() {
        self.navTitle?.textColor = .white
        self.vehicleNumberLabel?.textColor = .primaryColor
        self.recentTransactionTitleLabel?.textColor = .darkGreyDescriptionColor
        self.mainView?.addLightShadow()
        self.noTransactionAvailableLabel?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.vehicleDetailsTableView?.register(UINib(nibName: Cell.identifier.vehicleViewDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.vehicleViewDetailsTableViewCell)
        self.recentTransactionTableView?.register(UINib(nibName: Cell.identifier.transactionTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.transactionTableViewCell)
        [self.vehicleDetailsTableView, self.recentTransactionTableView].forEach {
            $0?.delegate = self
            $0?.dataSource = self
            $0?.separatorStyle = .none
        }
        
    }
    
    // MARK: Set Action
    private func setAction() {
        self.viewAllButton?.setup(title: AppLoacalize.textString.viewAll, type: .skip, isEnabled: true)
        
        self.viewAllButton?.addTarget(self, action: #selector(viewAllButtonAction(_:)), for: .touchUpInside)
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        
        let downloadFitmentLabelTapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabelGesture(gesture:)))
        self.downloadFitmentLabel?.isUserInteractionEnabled = true
        self.downloadFitmentLabel?.addGestureRecognizer(downloadFitmentLabelTapAction)
        
        let replaceFastTagLabellTapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabelGesture(gesture:)))
        self.replaceFastTagLabel?.isUserInteractionEnabled = true
        self.replaceFastTagLabel?.addGestureRecognizer(replaceFastTagLabellTapAction)
        
    }
    // MARK: View All Button Action
    @objc private func viewAllButtonAction(_ sender: UIButton) {
        router?.routeToNextVc(isFromViewAll: true)
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        router?.routeToNextVc(isFromViewAll: false)
    }
    
    // MARK: Action Download Fitment & Replace FastTag
    @objc func tapLabelGesture(gesture: UITapGestureRecognizer) {
        if gesture.view == downloadFitmentLabel {
            self.interactor?.passVehicleDetails(isDownload: true)
        } else if gesture.view == replaceFastTagLabel {
            self.interactor?.passVehicleDetails(isDownload: false)
        }
        
    }
    
    /* Check TransactionData Availability */
    private func tableHasData(isDataAvailable: Bool) {
        self.noTransactionAvailableLabel?.isHidden = isDataAvailable
        self.recentTransactionTableView?.isHidden = !isDataAvailable
        self.noTransactionAvailableLabel?.text = AppLoacalize.textString.noTransactionAvailable
        self.recentTransactionTableViewHeight?.constant = isDataAvailable ? CGFloat(self.transactionHistoryArray.count * 60) : 100
    }
}

// MARK: TableView delegate - datasource
extension VehicleDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.recentTransactionTableView {
            return self.transactionHistoryArray.count
        } else {
            return self.vehicleDetailsArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.recentTransactionTableView {
            guard let cell: TransactionTableViewCell = self.recentTransactionTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.transactionTableViewCell, for: indexPath) as? TransactionTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.updateVehicleTransactionHistoryData(data: self.transactionHistoryArray[indexPath.row])
            if indexPath.row == self.transactionHistoryArray.count - 1 {
                cell.dividerLineView?.isHidden = true
            }
            return cell
        } else {
            guard let cell: VehicleViewDetailsTableViewCell = self.vehicleDetailsTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.vehicleViewDetailsTableViewCell, for: indexPath) as? VehicleViewDetailsTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.setupView(vehicleDetailsData: self.vehicleDetailsArr[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.recentTransactionTableView {
            return 60
        } else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.recentTransactionTableView {
            if !self.transactionHistoryArray.isEmpty {
                self.interactor?.getExternalTransactionId(id: self.transactionHistoryArray[indexPath.row].externalTransactionId ?? "")
            }
        }
    }
}

// MARK: Interacter Requests
extension VehicleDetailsViewController {
    /* Get TransactionHisory */
    private func getTransactionHisory() {
        let fromDate = self.getStringFromDate(date: Date().getMonths(count: 3) ?? Date(), formate: .yyyyMMdd )
        let toDate = self.getStringFromDate(date: Date().getLastMonthEnd() ?? Date(), formate: .yyyyMMdd )
        self.interactor?.fetchVehicleTransactionHistory(fromDate: fromDate, toDate: toDate)
    }
}

// MARK: - DisplayLogic
extension VehicleDetailsViewController: VehicleDetailsDisplayLogic {
    
    /* Display VehicleDetails */
    func displayVehicleDetails(viewModel: VehicleDetails.VehicleDetailsModel.ViewModel, vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray?) {
        self.statusSwitch?.isUserInteractionEnabled = false
        self.vehicleNumberLabel?.text = vehicleListResultArray?.entityId?.setVehicleFormate() ?? ""
        self.vehicleListResultArray = vehicleListResultArray
        switch vehicleStatus {
        case .active:
            self.statusLabel?.textColor = .greenTextColor
            self.statusLabel?.text = AppLoacalize.textString.active
            self.statusSwitch?.isOn = true
            self.statusSwitch?.onTintColor = .greenTextColor
            self.statusSwitch?.thumbTintColor = .white
            
        case .inActive:
            self.statusLabel?.textColor = .midGreyColor
            self.statusLabel?.text = AppLoacalize.textString.inActive
            self.statusSwitch?.isOn = false
            self.statusSwitch?.onTintColor = .greenTextColor
            self.statusSwitch?.thumbTintColor = .midGreyColor
            
        case .blocked: break
        }
        
        self.vehicleDetailsArr = viewModel.vehicleDetailsDataArr ?? []
        self.vehicleDetailsTableViewHeight?.constant = CGFloat(self.vehicleDetailsArr.count * 65)
        self.vehicleDetailsTableView?.reloadData()
    }
    
    /* Route To NextVC after VehicleDetails */
    func displayVehicleDetailsToNextVC(isDownload: Bool) {
        if isDownload {
            self.router?.routeToFitmentCertificateVC()
        } else {
            self.router?.routeToReplaceFasTagVC()
        }
    }
    
    /* Display TransactionHistory */
    func displayTransactionHistory(data: VehicleTransactionModel?) {
        guard let responseData = data else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong)
            return
        }
        
        self.transactionHistoryArray = responseData.result ?? [VehicleTransactionArrayItem]()
        
        if self.transactionHistoryArray.isEmpty {
            self.tableHasData(isDataAvailable: false)
        } else {
            self.tableHasData(isDataAvailable: true)
            self.recentTransactionTableView?.reloadInMainThread()
        }
    }
    
    /* Route to vechile details */
    func displayTxnExternalID() {
        self.router?.routeToTransactionDetailsVC()
    }
}
