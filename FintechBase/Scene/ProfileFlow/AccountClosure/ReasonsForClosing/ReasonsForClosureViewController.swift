//
//  ReasonsForClosureViewController.swift
//  FintechBase
//
//  Created by Sravani Madala on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ReasonsForClosureDisplayLogic: AnyObject {
    func displayClosureReasonsResponse(viewModel: ReasonsForClosure.ReasonsForClosureModel.ViewModel)
}

class ReasonsForClosureViewController: UIViewController {
    var interactor: ReasonsForClosureBusinessLogic?
    var router: (NSObjectProtocol & ReasonsForClosureRoutingLogic & ReasonsForClosureDataPassing)?
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var checkBoxButton: UIButton?
    @IBOutlet private weak var concernTextLabel: UILabel?
    @IBOutlet private weak var reasonsTableView: UITableView?
    @IBOutlet private weak var proceedButton: UIButton?
    @IBOutlet private weak var cancelButton: UIButton?
    var reasonsList = [ClosureReasonsResult]() // ["Change of mobile number", "Withdraw wallet balance", "Unhappy with service", "Others"]
    var othersSelectedIndex: Int = 99
    var selectedTableIndex: Int = 99
    var isConcernCheck: Bool = false
    var selectedReason = ""
    var otherReasonText = ""
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
}

// MARK: - Initial Setup
extension ReasonsForClosureViewController {
    private func initialLoad() {
        self.setFont()
        self.setColor()
        self.setButton()
        self.setLoacalise()
        self.setTableView()
        self.interactor?.fetchClosureReasons()
    }
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.concernTextLabel?.text = AppLoacalize.textString.concernForCloseAccount
        self.titleLabel?.text = AppLoacalize.textString.reasonForLeaving
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
        self.concernTextLabel?.font = .setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .textBlackColor
        self.concernTextLabel?.textColor = .textBlackColor
    }
    
    // MARK: set Button
    private func setButton() {
        self.proceedButton?.setup(title: AppLoacalize.textString.proceed, type: .primary, isEnabled: false)
        self.cancelButton?.setup(title: AppLoacalize.textString.cancel, type: .secondary, isEnabled: true, secondaryButtonSetup: SecondaryButtonSetup(borderColor: .clear))
        self.proceedButton?.addTarget(self, action: #selector(proceedButtonAction(_:)), for: .touchUpInside)
        self.cancelButton?.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        self.checkBoxButton?.addTarget(self, action: #selector(checkBoxButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: set TableView
    private func setTableView() {
        self.reasonsTableView?.register(UINib(nibName: Cell.identifier.reasonsCellForClosure, bundle: nil), forCellReuseIdentifier: Cell.identifier.reasonsCellForClosure)
        self.reasonsTableView?.separatorStyle = .none
        self.reasonsTableView?.delegate = self
        self.reasonsTableView?.dataSource = self
    }
    
    // MARK: set Process Button
    private func proceedButtonValidation() {
        if isConcernCheck && !self.selectedReason.isEmpty {
            self.proceedButton?.setup(title: AppLoacalize.textString.proceed, type: .primary, isEnabled: true)
        } else {
            self.proceedButton?.setup(title: AppLoacalize.textString.proceed, type: .primary, isEnabled: false)
        }
    }
    
    // MARK: CheckBox Button logic
    private func enableConcernButton(enable: Bool) {
        checkBoxButton?.isSelected = enable
        if enable {
            checkBoxButton?.setImage(UIImage(named: Image.imageString.filledGreenCheckBox), for: .normal)
        } else {
            checkBoxButton?.setImage(UIImage(named: Image.imageString.checkBox), for: .normal)
        }
        self.isConcernCheck = enable
        self.proceedButtonValidation()
    }
}

// MARK: Button Actions
extension ReasonsForClosureViewController {
    // MARK: request call Button Action
    @objc private func proceedButtonAction(_ sender: UIButton) {
        AccountClosureData.sharedInstace.closureReason = self.selectedReason
        if walletBalance < 0.00 {
            self.router?.routeToNegativeBalanceVC()
        } else {
            self.router?.routeToBankAccountDetailsVC()
        }
    }
    // MARK: Cancel Button Action
    @objc private func cancelButtonAction(_ sender: UIButton) {
        self.popToViewController(destination: TabbarViewController.self)
    }
    // MARK: CheckBox Button Action
    @objc private func checkBoxButtonAction(_ sender: UIButton) {
        enableConcernButton(enable: !(checkBoxButton?.isSelected ?? false))
    }
}

// MARK: TableView Delegates and DataSource

extension ReasonsForClosureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reasonsList.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = reasonsTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.reasonsCellForClosure, for: indexPath) as? ReasonsCellForClosure else {
            return UITableViewCell()
        }
        if indexPath.row == reasonsList.count {
            tableViewCell.showSupportCustomView(isSelect: true)
        } else {
            tableViewCell.showSupportCustomView(isSelect: false)
        }
        
        tableViewCell.showOthersCustomView(isSelect: indexPath.row == othersSelectedIndex ? true : false)
        if self.reasonsList.count > 0 {
            tableViewCell.setListData(resonsTitle: indexPath.row == self.reasonsList.count ? "Others" : reasonsList[indexPath.row].reason,
                                      selectedIndex: indexPath.row == selectedTableIndex ? true : false)
        } else {
            tableViewCell.setListData(resonsTitle: "Others", selectedIndex: indexPath.row == selectedTableIndex ? true : false)
        }
        tableViewCell.isSupportButtonSelect = { isSelected in
            self.router?.routeToCustomerSupportVC()
        }
        tableViewCell.otherReasonText = { otherReasonText in
            self.selectedReason = otherReasonText
            self.proceedButtonValidation()
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTableIndex = indexPath.row
        if indexPath.row == reasonsList.count {
            othersSelectedIndex = indexPath.row
            self.selectedReason = ""
        } else {
            self.othersSelectedIndex = 99
            self.selectedReason = reasonsList[indexPath.row].reason ?? ""
        }
        self.proceedButtonValidation()
        tableView.reloadData()
    }
}

// MARK: - <ReasonsForClosureDisplayLogic> Methods
extension ReasonsForClosureViewController: ReasonsForClosureDisplayLogic {
    func displayClosureReasonsResponse(viewModel: ReasonsForClosure.ReasonsForClosureModel.ViewModel) {
        self.reasonsList = viewModel.closureReasonsModel?.result ?? []
        self.reasonsTableView?.reloadInMainThread()
    }
}
