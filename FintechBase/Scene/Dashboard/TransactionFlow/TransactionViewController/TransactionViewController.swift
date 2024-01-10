//
//  TransactionViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TransactionDisplayLogic: AnyObject {
    func displayDateFilterData(filterListData: [FilterListData])
    func displayTransactionHistoryData(data: TransactionHistoryModel?)
    func displayTxnExternalID()
}

class TransactionViewController: UIViewController {
  var interactor: TransactionBusinessLogic?
  var router: (NSObjectProtocol & TransactionRoutingLogic & TransactionDataPassing)?
  
    @IBOutlet private weak var mealCardButton: UIButton?
    @IBOutlet private weak var fastTagCardButton: UIButton?
    @IBOutlet private weak var segmentControlView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var slopeView: UIView?
    @IBOutlet private weak var qwImageView: UIImageView?
    @IBOutlet private weak var backGroungImageView: UIImageView?
    @IBOutlet private weak var transactionTableView: UITableView?
    
    @IBOutlet private weak var filterByButton: UIButton?
    @IBOutlet private weak var dateFilterButton: UIButton?
    @IBOutlet private weak var clearFilterButton: UIButton?
    @IBOutlet private weak var filterByLabel: UILabel?
    @IBOutlet private weak var filterDateLabel: UILabel?
    @IBOutlet private weak var filterImageVIew: UIImageView?
    @IBOutlet private weak var calenderImageView: UIImageView?
    @IBOutlet private weak var activeGreenImageView: UIImageView?
    @IBOutlet private weak var dividerLineView: UIView?
    @IBOutlet private weak var filterByView: UIView?
    @IBOutlet private weak var dateFilterView: UIView?
    @IBOutlet private weak var transactionHistoryTitleLabel: UILabel?
    @IBOutlet private weak var noTransactionAvailableLabel: UILabel?
    
    var dateFilterListArray = [FilterListData]()
    var selectedDateFilterIndex = 0
    var selectedFilterByIndex: Int?
    var fromDateText = ""
    var toDateText = ""
    private var pageNumber = 0
    private var totalPages = 0
    private var transactionHistoryArray = [TransactionHistoryArrayItem]()
    
    var displayDate: String = "" {
        willSet (newValue) {
            self.displayDate = newValue
        } didSet {
            if !displayDate.isEmpty {
                self.filterDateLabel?.text = self.displayDate
                //            Api calling
                self.pageNumber = 0
                self.interactor?.fetchTransactionHistoryList(isDateSelected: true, fromDate: fromDateText, toDate: toDateText, pageNumber: self.pageNumber)
            } else {
            }
        }
    }
    
    var displayFilterBy: String = "" {
        willSet (newValue) {
            self.displayFilterBy = newValue
        } didSet {
            if !displayFilterBy.isEmpty {
                self.activeGreenImageView?.isHidden = false
                self.clearFilterButton?.isHidden = false
            } else {
                self.activeGreenImageView?.isHidden = true
                self.clearFilterButton?.isHidden = true
            }
//            Api calling
        }
    }
    
    // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
      self.initialLoads()
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.fetchTransactionHistoryList(isDateSelected: true, fromDate: self.fromDateText, toDate: self.toDateText, pageNumber: self.pageNumber)
    }
}

// MARK: Initial Set Up
extension TransactionViewController {
    private func initialLoads() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setButton()
        self.setTableView()
        self.navigationController?.isNavigationBarHidden = true
        [self.segmentControlView, self.fastTagCardButton, self.mealCardButton].forEach {
            $0?.layer.cornerRadius = 16
        }
        [self.filterByView, self.dateFilterView].forEach {
            $0?.setRoundedBorder(radius: 5, color: UIColor.lightDisableBackgroundColor.cgColor)
        }
        self.activeGreenImageView?.isHidden = true
        self.clearFilterButton?.isHidden = true
        self.filterByView?.isHidden = true
        self.filterByButton?.isHidden = true
        noTransactionAvailableLabel?.isHidden = true
        self.interactor?.setFilterByData()
        self.interactor?.setDateFilterData()
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.noTransactionAvailableLabel?.text = AppLoacalize.textString.noTransactionAvailable
        self.transactionHistoryTitleLabel?.text = AppLoacalize.textString.transactionHistory
        self.titleLabel?.text = AppLoacalize.textString.myTransactions
        self.fastTagCardButton?.setTitle(AppLoacalize.textString.fasTagCard, for: .normal)
        self.mealCardButton?.setTitle(AppLoacalize.textString.mealCard, for: .normal)
    }
    
    // MARK: Font
    private func setFont() {
        self.noTransactionAvailableLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        self.filterDateLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.filterByLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.transactionHistoryTitleLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        self.titleLabel?.font = .setCustomFont(name: .bold, size: .x24)
        self.fastTagCardButton?.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
        self.mealCardButton?.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
    }
    
    // MARK: Color
    private func setColor() {
        self.noTransactionAvailableLabel?.textColor = .midGreyColor
        self.filterDateLabel?.textColor = .midGreyColor
        self.filterByLabel?.textColor = .midGreyColor
        self.transactionHistoryTitleLabel?.textColor = .darkGreyDescriptionColor
        self.titleLabel?.textColor = .white
        self.fastTagCardButton?.backgroundColor = .white
        self.mealCardButton?.backgroundColor = .clear
        self.fastTagCardButton?.setTitleColor(.primaryColor, for: .normal)
        self.mealCardButton?.setTitleColor(.lightDisableBackgroundColor, for: .normal)
        self.dividerLineView?.backgroundColor = .lightGreyTextColor
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.transactionTableView?.register(UINib(nibName: Cell.identifier.transactionTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.transactionTableViewCell)
        self.transactionTableView?.delegate = self
        self.transactionTableView?.dataSource = self
        self.transactionTableView?.separatorStyle = .none
    }
    
    // MARK: set Button
    private func setButton() {
        self.clearFilterButton?.setup(title: AppLoacalize.textString.clearFilter, type: .skip)
        self.clearFilterButton?.addTarget(self, action: #selector(clearFilterButtonAction(_:)), for: .touchUpInside)
        self.filterByButton?.addTarget(self, action: #selector(filterByButtonAction(_:)), for: .touchUpInside)
        self.dateFilterButton?.addTarget(self, action: #selector(dateFilterButtonAction(_:)), for: .touchUpInside)
        self.fastTagCardButton?.tag = 0
        self.mealCardButton?.tag = 1
        self.mealCardButton?.isUserInteractionEnabled = false
        [self.mealCardButton, self.fastTagCardButton].forEach {
            $0?.addTarget(self, action: #selector(segmentAction(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: Check Data for TableView
    private func tableHasData(isDataAvailable: Bool) {
        self.noTransactionAvailableLabel?.isHidden = isDataAvailable
        self.transactionTableView?.isHidden = !isDataAvailable
        self.noTransactionAvailableLabel?.text = AppLoacalize.textString.noTransactionAvailable
    }
    
    // MARK: Segment Action
    @objc private func segmentAction(_ sender: UIButton) {
        self.fastTagCardButton?.backgroundColor = sender.tag == 0 ? .white : .clear
        self.mealCardButton?.backgroundColor = sender.tag == 0 ? .clear : .white
        self.fastTagCardButton?.setTitleColor( sender.tag == 0 ? .primaryColor : .lightDisableBackgroundColor, for: .normal)
        self.mealCardButton?.setTitleColor(sender.tag == 0 ? .lightDisableBackgroundColor : .primaryColor, for: .normal)
    }
    
    // MARK: clear Filter Button Action
    @objc private func clearFilterButtonAction(_ sender: UIButton) {
        self.selectedFilterByIndex = nil
        self.displayFilterBy = ""
    }
    // MARK: Filter By Button Action
    @objc private func filterByButtonAction(_ sender: UIButton) {
        self.router?.routeToFilterListBottomSheetVC(isDateFilter: false)
    }
    // MARK: Date Filter Button Action
    @objc private func dateFilterButtonAction(_ sender: UIButton) {
        self.router?.routeToFilterListBottomSheetVC(isDateFilter: true)
    }

}

// MARK: tableView delegate - datasource
extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.transactionHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TransactionTableViewCell = self.transactionTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.transactionTableViewCell, for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateTransactionHistoryData(data: self.transactionHistoryArray[indexPath.row])
        if indexPath.row == self.transactionHistoryArray.count - 1 {
            cell.dividerLineView?.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.transactionHistoryArray.isEmpty {
            self.interactor?.getExternalTransactionId(id: self.transactionHistoryArray[indexPath.row].externalTxnId ?? "")
        }
    }
}

// MARK: - DisplayLogic
extension TransactionViewController: TransactionDisplayLogic {
    // MARK: Present Date Filter Data
    func displayDateFilterData(filterListData: [FilterListData]) {
        self.dateFilterListArray = filterListData
        
        self.dateFilterListArray.enumerated().forEach { (index, data) in
            if data.month == 0 {
                self.selectedDateFilterIndex = index
                self.fromDateText = self.getStringFromDate(date: Date().getThisMonthStart() ?? Date(), formate: .yyyyMMdd )
                self.toDateText = self.getStringFromDate(date: Date(), formate: .yyyyMMdd )
                self.interactor?.fetchTransactionHistoryList(isDateSelected: true, fromDate: self.fromDateText, toDate: self.toDateText, pageNumber: self.pageNumber)

                let date1 = self.getStringFromDate(date: Date().getThisMonthStart() ?? Date(), formate: .MMMdyyyy)
                let date2 = self.getStringFromDate(date: Date(), formate: .MMMdyyyy)
                self.filterDateLabel?.text = "\(date1) - \(date2)"
            }
        }
        
        UserDefaults.standard.removeObject(forKey: "FromDate")
        UserDefaults.standard.removeObject(forKey: "Todate")
    }
    
    func displayTransactionHistoryData(data: TransactionHistoryModel?) {
        self.transactionHistoryArray.removeAll()
        guard let data = data else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong)
            return
        }
        
        self.pageNumber = data.pagination?.pageNo ?? 0
        self.totalPages = (data.pagination?.totalPages ?? 0) - 1
        self.transactionHistoryArray.append(contentsOf: data.result ?? [TransactionHistoryArrayItem]())
        
        if self.pageNumber == self.totalPages {
            if !self.transactionHistoryArray.isEmpty {
                self.tableHasData(isDataAvailable: true)
                self.transactionTableView?.reloadInMainThread()
            } else {
                self.tableHasData(isDataAvailable: false)
            }
        } else if self.pageNumber < self.totalPages {
            self.pageNumber += 1
            self.interactor?.fetchTransactionHistoryList(isDateSelected: true, fromDate: self.fromDateText, toDate: self.toDateText, pageNumber: self.pageNumber)
        } else {
            self.tableHasData(isDataAvailable: false)
        }
    }
    
    /* route to vechile details */
    func displayTxnExternalID() {
        self.router?.routeToTransactionDetailsVC()
    }
}
