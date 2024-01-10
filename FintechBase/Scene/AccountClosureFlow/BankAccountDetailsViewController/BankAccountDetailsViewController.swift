//
//  BankAccountDetailsViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BankAccountDetailsDisplayLogic: AnyObject {
    func displayFieldDetails(accountDetailsField: [AccountDetailsField])
}

class BankAccountDetailsViewController: UIViewController {
    var interactor: BankAccountDetailsBusinessLogic?
    var router: (NSObjectProtocol & BankAccountDetailsRoutingLogic & BankAccountDetailsDataPassing)?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var walletBalanceView: UIView?
    @IBOutlet private weak var walletImageView: UIImageView?
    @IBOutlet private weak var staticRefundTitleLabel: UILabel?
    @IBOutlet private weak var balanceAmountLabel: UILabel?
    @IBOutlet private weak var staticAccountDetailsTitleLabel: UILabel?
    @IBOutlet private weak var staticAccountDescriptionTitleLabel: UILabel?
    @IBOutlet private weak var accountDetailsTableView: UITableView?
    
    private let selectedAmount = String(walletBalance)
    private var accountDetailsField = [AccountDetailsField]()
    private var accountDetailsData = BankAccountDetailsData()
    private var isEnable = false
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoad()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.walletBalanceView?.layer.cornerRadius = 10
    }
}

// MARK: - Initial Setup
extension BankAccountDetailsViewController {
    private func initialLoad() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setTableView()
        self.navigationController?.isNavigationBarHidden = true
        self.interactor?.getFieldDetails()
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.getYourAvailableWalletBalance
        self.staticRefundTitleLabel?.text = AppLoacalize.textString.refundableBalance
        self.staticAccountDetailsTitleLabel?.text = AppLoacalize.textString.accountDetails
        self.staticAccountDescriptionTitleLabel?.text = AppLoacalize.textString.accountDetailsDescription
        self.balanceAmountLabel?.text = rupeeSymbol + (selectedAmount).getRequiredFractionFormat()
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
        self.staticRefundTitleLabel?.font = .setCustomFont(name: .regular, size: .x14)
        self.staticAccountDetailsTitleLabel?.font = .setCustomFont(name: .semiBold, size: .x16)
        self.staticAccountDescriptionTitleLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.balanceAmountLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
        self.staticRefundTitleLabel?.textColor = .midGreyColor
        self.staticAccountDetailsTitleLabel?.textColor = .primaryButtonColor
        self.staticAccountDescriptionTitleLabel?.textColor = .descriptionGreyColor.withAlphaComponent(0.5)
        self.balanceAmountLabel?.textColor = .primaryButtonColor
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.accountDetailsTableView?.register(UINib(nibName: Cell.identifier.addBankCellTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.addBankCellTableViewCell)
        self.accountDetailsTableView?.register(UINib(nibName: Cell.identifier.notesTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.notesTableViewCell)
        self.accountDetailsTableView?.register(UINib(nibName: Cell.identifier.proceedCancelButtonTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.proceedCancelButtonTableViewCell)
        self.accountDetailsTableView?.delegate = self
        self.accountDetailsTableView?.dataSource = self
        self.accountDetailsTableView?.separatorStyle = .none
    }
    // MARK: Check Verify Button Validation
    private func setProceedButtonState() {
        let cell = self.accountDetailsTableView?.cellForRow(at: IndexPath(row: 0, section: 2)) as? ProceedCancelButtonTableViewCell
        if !self.accountDetailsData.accountNumber.isEmpty && !self.accountDetailsData.reAccountNumber.isEmpty && !self.accountDetailsData.ifscNumber.isEmpty && !self.accountDetailsData.benificiaryName.isEmpty {
            self.isEnable = true
            cell?.primaryButton?.setPrimaryButtonState(isEnabled: true)
        } else {
            self.isEnable = false
            cell?.primaryButton?.setPrimaryButtonState(isEnabled: false)
        }
    }
}

// MARK: tableView delegate - datasource
extension BankAccountDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.accountDetailsField.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell: AddBankCellTableViewCell = self.accountDetailsTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.addBankCellTableViewCell, for: indexPath) as? AddBankCellTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.setUPIIDTextfieldView(accountDetailsField: self.accountDetailsField[indexPath.row], index: indexPath.row, accountDetailsData: self.accountDetailsData)
            cell.isCustomTextFieldData = { inputText, tagVal in
                switch tagVal {
                case 0:
                    self.accountDetailsData.accountNumber = inputText
                case 1:
                    self.accountDetailsData.reAccountNumber = inputText
                case 2:
                    self.accountDetailsData.ifscNumber = inputText
                case 3:
                    self.accountDetailsData.benificiaryName = inputText
                default:
                    break
                }
                self.setProceedButtonState()
            }
            return cell
        case 1:
            guard let cell: NotesTableViewCell = self.accountDetailsTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.notesTableViewCell, for: indexPath) as? NotesTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.setUpView(title: AppLoacalize.textString.pleaseNote, description: AppLoacalize.textString.creditAccountDetailsNotes)
            return cell
        case 2:
            guard let cell: ProceedCancelButtonTableViewCell = self.accountDetailsTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.proceedCancelButtonTableViewCell, for: indexPath) as? ProceedCancelButtonTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.setUpButton(primaryButton: ButtonData(title: AppLoacalize.textString.proceed, isEnable: self.isEnable), skipButton: ButtonData(title: AppLoacalize.textString.cancel, isEnable: true))
            cell.onClikButton = { buttonTag in
                if buttonTag == 1 {
                    if self.accountDetailsData.accountNumber == self.accountDetailsData.reAccountNumber {
                        AccountClosureData.sharedInstace.accountNo = self.accountDetailsData.accountNumber
                        AccountClosureData.sharedInstace.ifscCode = self.accountDetailsData.ifscNumber
                        AccountClosureData.sharedInstace.beneficiaryName = self.accountDetailsData.benificiaryName
                        self.router?.routeToUploadDocumentVC()
                    } else {
                        showSuccessToastMessage(message: "Account Number Mismatch", messageColor: .white, bgColour: UIColor.redErrorColor)
                    }
                    
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 135
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if !self.transactionHistoryArray.isEmpty {
//            self.interactor?.getExternalTransactionId(id: self.transactionHistoryArray[indexPath.row].externalTxnId ?? "")
//        }
    }
}

// MARK: - <BankAccountDetailsDisplayLogic> Methods
extension BankAccountDetailsViewController: BankAccountDetailsDisplayLogic {
    func displayFieldDetails(accountDetailsField: [AccountDetailsField]) {
        self.accountDetailsField = accountDetailsField
        self.accountDetailsTableView?.reloadInMainThread()
    }
}
