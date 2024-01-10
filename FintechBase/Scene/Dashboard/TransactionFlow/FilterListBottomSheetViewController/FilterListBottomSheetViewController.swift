//
//  FilterListBottomSheetViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol FilterListBottomSheetDisplayLogic: AnyObject {
    func displayFilterListData(viewModel: FilterListBottomSheet.FilterListBottomSheetModel.ViewModel, selectedIndex: Int?)
}

class FilterListBottomSheetViewController: UIViewController {
    var interactor: FilterListBottomSheetBusinessLogic?
    var router: (NSObjectProtocol & FilterListBottomSheetRoutingLogic & FilterListBottomSheetDataPassing)?
    
    @IBOutlet private weak var applyButton: UIButton?
    @IBOutlet private weak var closeButton: UIButton?
    @IBOutlet private weak var viewContent: UIView?
    @IBOutlet private weak var closeImageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var filterListTableView: UITableView?
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint?
    
    var selectedDate: ((String, Int, String, String) -> Void)?
    var selectedFilterByValue: ((String, Int) -> Void)?
    var filterListArray = [FilterListData]()
    var filterState: FilterState?
    var selectedIndex: Int?
    var isExpand: Bool?
    var indexPath = IndexPath()
    var displayFilterValue = ""
    var displayDate = ""
    var fromDateText = ""
    var toDateText = ""
    private var month: Int = 0
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.view.applyCrossDissolvePresentAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.filterState == .dateFilter {
            /* To get Old Values */
            let cell = self.filterListTableView?.cellForRow(at: self.indexPath) as? FilterListTableViewCell
            let fromField = cell?.fromDateInputField?.contentTextfield?.text ?? ""
            let toField = cell?.toDateInputField?.contentTextfield?.text ?? ""
            
            if fromField.isEmpty || toField.isEmpty {
                UserDefaults.standard.set(self.fromDateText, forKey: "FromDate")
                UserDefaults.standard.set(self.toDateText, forKey: "Todate")
            }
        }
    }
}

// MARK: Initial Set Up
extension FilterListBottomSheetViewController {
    private func initialLoads() {
        self.setFont()
        self.setColor()
        self.setButton()
        self.setTableView()
        self.viewContent?.layer.cornerRadius = 16
        self.navigationController?.isNavigationBarHidden = true
        self.interactor?.getFilterListData()
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.filterListTableView?.register(UINib(nibName: Cell.identifier.filterListTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.filterListTableViewCell)
        self.filterListTableView?.delegate = self
        self.filterListTableView?.dataSource = self
        self.filterListTableView?.separatorStyle = .none
    }
    
    // MARK: Set Button
    private func setButton() {
        self.applyButton?.setup(title: AppLoacalize.textString.apply, type: .primary, isEnabled: false)
        self.applyButton?.addTarget(self, action: #selector(applyButtonAction(_:)), for: .touchUpInside)
        self.closeButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Apply Button Action
    @objc private func applyButtonAction(_ sender: UIButton) {
        if self.filterState == .dateFilter {
            if month == -1 {
                self.selectedDate?(self.displayDate, self.selectedIndex ?? 0, self.fromDateText, self.toDateText)
            } else {
                self.passSelectedData(month: self.month)
            }
        } else {
            self.selectedFilterByValue?(self.displayFilterValue, self.selectedIndex ?? 0)
        }
    }
    // MARK: Close Button Action
    @objc private func closeButtonAction(_ sender: UIButton) {
        self.view.applyCrossDissolveDismissAnimation(handler: { isExecuted in
            if isExecuted {
                self.dismiss(animated: isExecuted)
            }
        })
    }
    
    /* Pass Selected Data */
    private func passSelectedData(month: Int = 0) {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var fromDate = ""
        var toDate = ""
        if month == 0 {
            fromDate = formatter.string(from: currentDate.getThisMonthStart() ?? Date())
            toDate = formatter.string(from: currentDate)
            
            formatter.dateFormat = "MMM d, yyyy"
            let date1 = formatter.string(from: currentDate.getThisMonthStart() ?? Date())
            let date2 = formatter.string(from: currentDate)
            self.fromDateText = fromDate
            self.toDateText = toDate
            self.displayDate = "\(date1) - \(date2)"
        } else {
            fromDate = formatter.string(from: currentDate.getMonths(count: month) ?? Date())
            toDate = formatter.string(from: currentDate.getLastMonthEnd() ?? Date())
            
            formatter.dateFormat = "MMM d, yyyy"
            let date1 = formatter.string(from: currentDate.getMonths(count: month) ?? Date())
            let date2 = formatter.string(from: currentDate.getLastMonthEnd() ?? Date())
            
            self.fromDateText = fromDate
            self.toDateText = toDate
            self.displayDate = "\(date1) - \(date2)"
        }
        UserDefaults.standard.removeObject(forKey: "FromDate")
        UserDefaults.standard.removeObject(forKey: "Todate")
        
        self.selectedDate?(self.displayDate, self.selectedIndex ?? 0, self.fromDateText, self.toDateText)
    }
}

// MARK: - UITableViewDataSource
extension FilterListBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filterListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.filterListTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.filterListTableViewCell) as? FilterListTableViewCell else {
            return UITableViewCell.init()
        }
        cell.selectionStyle = .none
        if self.filterState == .dateFilter {
            cell.selectedIndexCell = self.selectedIndex
            cell.datePresentView = self.view
            self.indexPath = indexPath
            cell.setDateFilterValues(titleString: filterListArray[indexPath.row].title ?? "", isExpand: self.isExpand ?? false, indexPathRow: indexPath.row)
            cell.dividerLine?.isHidden = (indexPath.row == self.filterListArray.count - 1) ? true : false
            
            if isExpand ?? false && selectedIndex == indexPath.row {
                self.filterListTableView?.scrollToBottom()
            }
            
            cell.passDateValue = { (displayDate, fromDate, toDate, isEmpty) in
                if isEmpty {
                    self.applyButton?.setPrimaryButtonState(isEnabled: false)
                } else {
                    self.applyButton?.setPrimaryButtonState(isEnabled: true)
                    self.fromDateText = fromDate
                    self.toDateText = toDate
                    self.displayDate = displayDate
                }
            }
        } else {
            cell.selectedIndexCell = self.selectedIndex
            self.indexPath = indexPath
            cell.setFilterByValues(titleString: filterListArray[indexPath.row].title ?? "", indexPathRow: indexPath.row)
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FilterListBottomSheetViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.filterState == .dateFilter {
            if isExpand ?? false && selectedIndex == indexPath.row {
                return 180
            } else {
                return 55
            }
        } else {
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.filterState == .dateFilter {
            self.selectedIndex = indexPath.row
            self.isExpand = false
            self.tableViewHeightConstraint?.constant = CGFloat(filterListArray.count * 55)
            self.applyButton?.setPrimaryButtonState(isEnabled: true)
            if filterListArray[indexPath.row].month == -1 {
                self.isExpand = true
                self.applyButton?.setPrimaryButtonState(isEnabled: false)
                self.tableViewHeightConstraint?.constant = CGFloat((filterListArray.count * 55) + 80)
                self.filterListTableView?.scrollToBottom()
            }
            UserDefaults.standard.removeObject(forKey: "FromDate")
            UserDefaults.standard.removeObject(forKey: "Todate")
            self.month = filterListArray[indexPath.row].month ?? 0
            self.filterListTableView?.reloadData()
        } else {
            self.selectedIndex = indexPath.row
            self.applyButton?.setPrimaryButtonState(isEnabled: self.selectedIndex != nil ? true : false)
            self.displayFilterValue = filterListArray[indexPath.row].title ?? ""
            self.filterListTableView?.reloadData()
        }
        
    }
}

// MARK: - DisplayLogic
extension FilterListBottomSheetViewController: FilterListBottomSheetDisplayLogic {
    /* Display filterlist data */
    func displayFilterListData(viewModel: FilterListBottomSheet.FilterListBottomSheetModel.ViewModel, selectedIndex: Int?) {
        self.filterListArray = viewModel.filterListData
        self.filterState = viewModel.filterState
        self.selectedIndex = selectedIndex
        self.month = filterListArray[selectedIndex ?? 0].month ?? 0
        self.titleLabel?.text = self.filterState == .dateFilter ? AppLoacalize.textString.selectDateRange : AppLoacalize.textString.filter
        if self.filterState == .dateFilter {
            self.tableViewHeightConstraint?.constant = CGFloat((filterListArray.count * 55) + ((filterListArray[selectedIndex ?? 0].month ?? 0) == -1 ? 80 : 0))
            self.applyButton?.setPrimaryButtonState(isEnabled: filterListArray[selectedIndex ?? 0].month == -1 ? false : true)
            self.isExpand = filterListArray[selectedIndex ?? 0].month == -1 ? true : false
            /* For retrieve Old Values */
            let fromDate = UserDefaults.standard.string(forKey: "FromDate") ?? ""
            let toDate = UserDefaults.standard.string(forKey: "Todate") ?? ""
            self.fromDateText = fromDate
            self.toDateText = toDate
        } else {
            isExpand = false
            self.applyButton?.setPrimaryButtonState(isEnabled: self.selectedIndex != nil ? true : false)
            self.tableViewHeightConstraint?.constant = CGFloat(filterListArray.count * 55)
        }
        self.filterListTableView?.reloadData()
    }
}
