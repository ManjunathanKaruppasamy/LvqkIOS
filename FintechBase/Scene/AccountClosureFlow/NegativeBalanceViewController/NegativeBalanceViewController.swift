//
//  NegativeBalanceViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NegativeBalanceDisplayLogic: AnyObject {
    func displayPayUResponse(paymentParam: PayUResponse)
    func displayWalletBalanceResponse(viewModel: NegativeBalance.NegativeBalanceModel.ViewModel)
}

class NegativeBalanceViewController: UIViewController {
    var interactor: NegativeBalanceBusinessLogic?
    var router: (NSObjectProtocol & NegativeBalanceRoutingLogic & NegativeBalanceDataPassing)?

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var walletBalanceView: UIView?
    @IBOutlet private weak var walletImageView: UIImageView?
    @IBOutlet private weak var staticRefundTitleLabel: UILabel?
    @IBOutlet private weak var balanceAmountLabel: UILabel?
    
    @IBOutlet private weak var notesView: UIView?
    @IBOutlet private weak var notesTitleLabel: UILabel?
    @IBOutlet private weak var notesDescriptionLabel: UILabel?
    @IBOutlet private weak var cancelButton: UIButton?
    
    @IBOutlet private weak var paymetMethodView: PaymentMethodView?
    
    var selectedAmount: String = String(walletBalance)
    var payUResponse: PayUResponse?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchBalance()
    }
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
        self.notesView?.setCornerRadius()
        self.walletBalanceView?.layer.cornerRadius = 10
        self.paymetMethodView?.roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
}

// MARK: - Initial Setup
extension NegativeBalanceViewController {
    private func initialLoad() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.getPaymentMethod()
        self.navigationController?.isNavigationBarHidden = true
        self.cancelButton?.setup(title: AppLoacalize.textString.cancel, type: .skip, isEnabled: true)
        self.cancelButton?.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
    }

    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.negativeBalanceTitle
        self.staticRefundTitleLabel?.text = AppLoacalize.textString.refundableBalance
        self.notesTitleLabel?.text = AppLoacalize.textString.pleaseNote
        self.notesDescriptionLabel?.text = AppLoacalize.textString.negativeBalanceNotes
        self.balanceAmountLabel?.text = rupeeSymbol + (selectedAmount).getRequiredFractionFormat()
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
        self.staticRefundTitleLabel?.font = .setCustomFont(name: .regular, size: .x14)
        self.balanceAmountLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
        self.notesTitleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.notesDescriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
        self.staticRefundTitleLabel?.textColor = .midGreyColor
        self.balanceAmountLabel?.textColor = .redErrorColor
        self.notesTitleLabel?.textColor = .orangeColor
        self.notesDescriptionLabel?.textColor = .blusihGryColor
    }
    
    // MARK: get Payment Method
    private func getPaymentMethod() {
        self.paymetMethodView?.onTapPaymentView = { viewTag in
            if viewTag == 1 { // UPI Apps
                self.router?.routeToUPIAppVC()
            } else { // Other payment option
                self.interactor?.getGenerateHashResponse(amount: self.selectedAmount.replace(string: "-", replacement: ""), extTxnId: CommonFunctions().getPGtransactionID())
            }
        }
    }
    
    // MARK: Set Button Action
    @objc private func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func fetchBalance() {
        self.interactor?.getBalance()
    }
}

// MARK: - <NegativeBalanceDisplayLogic> Methods
extension NegativeBalanceViewController: NegativeBalanceDisplayLogic {
    /* Display PayU Response */
    func displayPayUResponse(paymentParam: PayUResponse) {
        self.payUResponse = paymentParam
        self.router?.routeToPayUVC()
    }
    
    /* Wallet Balance Response */
    func displayWalletBalanceResponse(viewModel: NegativeBalance.NegativeBalanceModel.ViewModel) {
        let balance = (viewModel.getBalanceResponse?.result?.first?.balance ?? AppLoacalize.textString.zeroAmount).getRequiredFractionFormat()
        
        if balance == "0.00" {
            self.router?.routeToOTPController()
        } else {
            self.balanceAmountLabel?.text = rupeeSymbol + (balance).getRequiredFractionFormat()
            self.selectedAmount = balance
        }
    }
}
