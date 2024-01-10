//
//  AddMoneyViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddMoneyDisplayLogic: AnyObject {
    func displayPayUResponse(paymentParam: PayUResponse)
    func displayCardDetails(cardDetails: GetCardResultArray?, balanceDetails: GetBalanceResult?)
//    func displayCardDetails(cardDetails: MultiCardArray?, balanceDetails: MultiCardBalance?)
}

class AddMoneyViewController: UIViewController {
    var interactor: AddMoneyBusinessLogic?
    var router: (NSObjectProtocol & AddMoneyRoutingLogic & AddMoneyDataPassing)?
    private var selectedCardResult: GetCardResultArray?
    private var selectedCardBalance: GetBalanceResult?
//    private var selectedCardResult: MultiCardArray?
//    private var selectedCardBalance: MultiCardBalance?
    
    @IBOutlet weak var payButton: UIButton?
    @IBOutlet weak var amountListView: OptionView?
    @IBOutlet weak var amountTextField: CustomFloatingTextField?
    @IBOutlet weak var dividerLineView: UIView?
    @IBOutlet weak var errorLabel: UILabel?
    @IBOutlet weak var errorImageView: UIImageView?
    @IBOutlet weak var errorView: UIView?
    @IBOutlet weak var errorMainView: UIView?
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var navigationView: UIView?
    @IBOutlet weak var navigationTitle: UILabel?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var balanceView: UIView?
    @IBOutlet weak var valueAmountBalLabel: UILabel?
    @IBOutlet weak var staticAmountBalLabel: UILabel?
    
    @IBOutlet weak var selectPaymentMethodLabel: UILabel?
    @IBOutlet weak var upiMainView: UIView?
    
    @IBOutlet weak var upiAppView: UIView?
    @IBOutlet weak var upiAppTitle: UILabel?
    @IBOutlet weak var upiAppDescription: UILabel?
    @IBOutlet weak var staticOrLabel: UILabel?
    
    @IBOutlet weak var enterUpiIdView: UIView?
    @IBOutlet weak var enterUpiIdTitle: UILabel?
    @IBOutlet weak var enterUpiIdTextfield: UITextField?
    @IBOutlet weak var verifyButton: UIButton?
    @IBOutlet weak var enterUpiIdDescription: UILabel?
    @IBOutlet weak var continueButton: UIButton?
    
    @IBOutlet weak var otherPaymentView: UIView?
    @IBOutlet weak var otherPaymentTitle: UILabel?
    @IBOutlet weak var otherPaymentDescription: UILabel?
    
    var selectedAmount = "0"
    var payUResponse: PayUResponse?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.getBalanceForCard()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewContent?.layer.cornerRadius = 16
        self.errorView?.layer.cornerRadius = 10
        self.upiMainView?.layer.cornerRadius = 16
//        self.upiMainView?.setRoundedBorder(radius: 16, color: UIColor.lightDisableBackgroundColor.cgColor)
//        self.otherPaymentView?.setRoundedBorder(radius: 16, color: UIColor.lightDisableBackgroundColor.cgColor)
        self.navigationView?.applyGradient(isVertical: true, colorArray: [.appDarkPinkColor, .appDarkBlueColor])
    }
}

// MARK: Initial Set Up
extension AddMoneyViewController {
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setAction()
        self.setColor()
        self.setFont()
        self.setStaticText()
        self.setAmountTextfieldView()
        self.enterUpiIdTextfield?.delegate = self
        self.errorMainView?.isHidden = true
        setOptionListView(data: ["₹ 500", "₹ 1000", "₹ 1500", "₹ 2000", "₹ 2500", "₹ 3000"])
    }
    
    // MARK: Color
    private func setColor() {
        self.selectPaymentMethodLabel?.textColor = .midGreyColor
        self.navigationTitle?.textColor = .white
        self.staticAmountBalLabel?.textColor = .midGreyColor
        self.valueAmountBalLabel?.textColor = .secondaryBlackTextColor
        self.errorLabel?.textColor = .midGreyColor
        self.upiAppTitle?.textColor = .primaryColor
        self.upiAppDescription?.textColor = .greenColor
        self.staticOrLabel?.textColor = .blusihGryColor
        
        self.enterUpiIdTitle?.textColor = .textBlackColor
        self.enterUpiIdTextfield?.textColor = .textBlackColor
        self.enterUpiIdDescription?.textColor = .darkGreyDescriptionColor
        self.otherPaymentTitle?.textColor = .textBlackColor
        self.otherPaymentDescription?.textColor = .redErrorColor
        self.viewContent?.addLightShadow()
        self.upiMainView?.addLightShadow()
    }
    
    // MARK: Font
    private func setFont() {
        self.selectPaymentMethodLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.navigationTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.staticAmountBalLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.valueAmountBalLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.errorLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.upiAppTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
        self.upiAppDescription?.font = UIFont.setCustomFont(name: .regular, size: .x10)
        self.staticOrLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.enterUpiIdTitle?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.enterUpiIdTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        self.enterUpiIdDescription?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.otherPaymentTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
        self.otherPaymentDescription?.font = UIFont.setCustomFont(name: .regular, size: .x10)
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.selectPaymentMethodLabel?.text = AppLoacalize.textString.selectPaymentMethod
        self.navigationTitle?.text = AppLoacalize.textString.addMoney
        self.staticAmountBalLabel?.text = AppLoacalize.textString.accountBalance
        self.errorLabel?.text = AppLoacalize.textString.balanceLowErrorDescription
        self.upiAppTitle?.text = AppLoacalize.textString.payviaUPIApps
        self.upiAppDescription?.text = AppLoacalize.textString.noAdditionalChargesforUPItransactions
        self.staticOrLabel?.text = AppLoacalize.textString.orString
        self.enterUpiIdTitle?.text = AppLoacalize.textString.enterUPITitle
        self.enterUpiIdTextfield?.placeholder = AppLoacalize.textString.enterUPIPlaceholder
        self.enterUpiIdDescription?.text = AppLoacalize.textString.enterUPIDescription
        self.otherPaymentTitle?.text = AppLoacalize.textString.otherPaymentOptions
        self.otherPaymentDescription?.text = AppLoacalize.textString.otherPaymentDescription
    }
    
    // MARK: Set Action
    private func setAction() {
        self.continueButton?.setup(title: AppLoacalize.textString.continueText, type: .primary, isEnabled: false)
        self.verifyButton?.setup(title: AppLoacalize.textString.verify, type: .skip, isEnabled: false)
        self.payButton?.setup(title: AppLoacalize.textString.proceedToPay, type: .primary, isEnabled: false)
        self.payButton?.addTarget(self, action: #selector(payBttnAction(_:)), for: .touchUpInside)
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        self.continueButton?.addTarget(self, action: #selector(continueBttnAction(_:)), for: .touchUpInside)
        self.verifyButton?.addTarget(self, action: #selector(verifyBttnAction(_:)), for: .touchUpInside)
        let otherPaymentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(otherPaymentTapped(tapGestureRecognizer:)))
        otherPaymentView?.isUserInteractionEnabled = true
        otherPaymentView?.addGestureRecognizer(otherPaymentTapGestureRecognizer)
        let upiAppViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(upiAppTapped(tapGestureRecognizer:)))
        upiAppView?.isUserInteractionEnabled = true
        upiAppView?.addGestureRecognizer(upiAppViewTapGestureRecognizer)
    }
    // MARK: Other Payment View Action
    @objc private func otherPaymentTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if Double(selectedAmount) ?? 0 > 0 {
            self.interactor?.getGenerateHashResponse(amount: self.selectedAmount, extTxnId: CommonFunctions().getPGtransactionID())
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.zeroAmountValidation, duration: 1)
        }
    }
    // MARK: upi App View Action
    @objc private func upiAppTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if Double(selectedAmount) ?? 0 > 0 {
            self.router?.routeToUPIAppVC()
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.zeroAmountValidation, duration: 1)
        }
    }
    // MARK: Pay Button Action
    @objc private func payBttnAction(_ sender: UIButton) {
    }
    // MARK: Continue Button Action
    @objc private func continueBttnAction(_ sender: UIButton) {
    }
    // MARK: Verify Button Action
    @objc private func verifyBttnAction(_ sender: UIButton) {
        print("tapppedd")
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: OptionListView
    private func setOptionListView(data: [String]) {
        self.amountListView?.setOptionType(type: .list, buttonTexts: data, listSelectionType: .single, listScroll: .horizontal)
        amountListView?.onChoosenOption = { [weak self] choosenArray in
            self?.selectedAmount = choosenArray.first?.replacingOccurrences(of: rupeeSymbol, with: "").trim ?? ""
            self?.amountTextField?.contentTextfield?.text = choosenArray.first
            self?.payButton?.setPrimaryButtonState(isEnabled: choosenArray.count == 0 ? false : true)
        }
    }
    
    // MARK: Set AmountTextfield View
    private func setAmountTextfieldView() {
        self.amountTextField?.isCurrency = true
        self.amountTextField?.setupField(selectType: .text, title: AppLoacalize.textString.enterAnyAmount, placeHolder: rupeeSymbol)
        self.amountTextField?.contentTextfield?.keyboardType = .numberPad
        self.amountTextField?.contentTextfield?.text = "\(rupeeSymbol) " + "0"
        self.amountTextField?.contentTextfield?.textColor = .secondaryBlackTextColor
        self.amountTextField?.onClearOptions = {
            self.amountListView?.clearSelectedList()
            
        }
        self.amountTextField?.checkTextField = { text in
            var amount = self.amountTextField?.contentTextfield?.text?.replacingOccurrences(of: ",", with: "")
            amount = amount?.replacingOccurrences(of: rupeeSymbol, with: "").trim
            self.selectedAmount = amount ?? ""
            self.payButton?.setPrimaryButtonState(isEnabled: (Double(amount ?? "0") ?? 0 > 0) ? true : false)
        }
    }
    
}

// MARK: TextField Delegate methods
extension AddMoneyViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.verifyButton?.setSkipButtonState(isEnabled: false)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let contentTextfield = enterUpiIdTextfield?.text else {
            return
        }
        
        if textField == enterUpiIdTextfield && !contentTextfield.isEmpty && contentTextfield.contains("@") {
            self.verifyButton?.setSkipButtonState(isEnabled: true)
        } else {
            self.verifyButton?.setSkipButtonState(isEnabled: false)
        }
    }
}

// MARK: Display logic
extension AddMoneyViewController: AddMoneyDisplayLogic {
    /* Display Card Details */
    func displayCardDetails(cardDetails: GetCardResultArray?, balanceDetails: GetBalanceResult?) {
        self.selectedCardResult = cardDetails
        self.selectedCardBalance = balanceDetails
        walletBalance = Double((balanceDetails?.balance ?? AppLoacalize.textString.zeroAmount).getRequiredFractionFormat()) ?? 0.00
        self.valueAmountBalLabel?.text = rupeeSymbol + (balanceDetails?.balance ?? AppLoacalize.textString.zeroAmount).getRequiredFractionFormat()
        if Double(balanceDetails?.balance ?? AppLoacalize.textString.zeroAmount) ?? 0.00 <= minimumBalance {
            self.valueAmountBalLabel?.textColor = .redErrorColor
            self.errorMainView?.isHidden = false
        } else {
            self.valueAmountBalLabel?.textColor = .secondaryBlackTextColor
            self.errorMainView?.isHidden = true
        }
        
    }
    
    /* Display PayU Response */
    func displayPayUResponse(paymentParam: PayUResponse) {
        self.payUResponse = paymentParam
        self.router?.routeToPayUVC()
    }
}
