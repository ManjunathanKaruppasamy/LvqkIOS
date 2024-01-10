//
//  VerifyAadharViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VerifyAadharDisplayLogic: AnyObject {
  func displaySomething(viewModel: VerifyAadhar.Something.ViewModel)
}

class VerifyAadharViewController: UIViewController {
    @IBOutlet private weak var navigationTitleLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var subTitleLabel: UILabel?
    @IBOutlet private weak var cardView: UIView?
    @IBOutlet private weak var aadharHoldView: CustomFloatingTextField?
    @IBOutlet private weak var termsAndConditionsView: UIView?
    @IBOutlet private weak var continueButton: UIButton?
    @IBOutlet private weak var statuBarView: UIView?
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var checkBoxButton: UIButton?
    @IBOutlet private weak var termsLabel: UILabel?
    var interactor: VerifyAadharBusinessLogic?
    var router: (NSObjectProtocol & VerifyAadharRoutingLogic & VerifyAadharDataPassing)?
    private var acceptTerms = false
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationView?.applyGradient(isVertical: true, colorArray: [.statusBarColor, .appDarkBlueColor])
    }
}

// MARK: Initial Setup
extension VerifyAadharViewController {
    
    /* Initial Loads */
    private func initializeUI() {
        [navigationTitleLabel].forEach {
            $0?.textColor = .white
            $0?.font = .setCustomFont(name: .semiBold, size: .x18)
            $0?.text = AppLoacalize.textString.emailSettings
        }
        
        [titleLabel].forEach {
            $0?.textColor = .primaryColor
            $0?.font = .setCustomFont(name: .regular, size: .x18)
            $0?.text = AppLoacalize.textString.changeEmailID
        }
        
        [subTitleLabel].forEach {
            $0?.textColor = .darkGreyDescriptionColor
            $0?.font = .setCustomFont(name: .regular, size: .x14)
            $0?.text = AppLoacalize.textString.verifyAadharSubtitle
        }
        
        [aadharHoldView].forEach {
            $0?.setupField(selectType: .text, title: AppLoacalize.textString.enterYourAAdhar, placeHolder: AppLoacalize.textString.placeholderAadhar)
            $0?.contentTextfield?.textColor = .primaryColor
            $0?.contentTextfield?.delegate = self
        }
        
        [termsLabel].forEach {
            $0?.font = .setCustomFont(name: .regular, size: .x12)
            $0?.text = AppLoacalize.textString.terms
            enableTermsAndContionBtn(enable: false)
        }
        
        [continueButton].forEach {
            $0?.setup(title: AppLoacalize.textString.continueText, type: .primary, isEnabled: true)
            $0?.tintColor = .clear
        }
        
        [checkBoxButton].forEach {
            $0?.setBackgroundImage(UIImage(named: Image.imageString.checkBox), for: .normal)
            $0?.addTarget(self, action: #selector(checkBoxBtnAction), for: .touchUpInside)
            $0?.tintColor = .clear
        }
        
        cardView?.addLightShadow(radius: 16)
        statuBarView?.backgroundColor = .statusBarColor
        backButton?.addTarget(self, action: #selector(backToVC), for: .touchUpInside)
        continueButton?.addTarget(self, action: #selector(continueBtnAction), for: .touchUpInside)
        
        self.view.backgroundColor = .whitebackgroundColor
        navigationController?.navigationBar.isHidden = true
        
    }
}

// MARK: Button Actions
extension VerifyAadharViewController {
   
    // MARK: EnableTermsAndContionBtn Action
    private func enableTermsAndContionBtn(enable: Bool) {
        termsLabel?.textColor =  enable ? .primaryColor : .gray2
        checkBoxButton?.isSelected = enable
        enable ? checkBoxButton?.setBackgroundImage(UIImage(named: Image.imageString.fillcheckBox), for: .selected) :
        checkBoxButton?.setBackgroundImage(UIImage(named: Image.imageString.checkBox), for: .normal)
        acceptTerms = enable
    }
    
    // MARK: Back Action
    @objc private func backToVC() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: ContinueBtn Action
    @objc private func continueBtnAction() {
        if acceptTerms && aadharHoldView?.contentTextfield?.text?.count == 14 {
            router?.routeToOtpVerificationVC()
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.aadharFailure)
        }
    }
    // MARK: CheckBox Btn Action
    @objc private func checkBoxBtnAction() {
        enableTermsAndContionBtn(enable: !(checkBoxButton?.isSelected ?? false))
    }
}

// MARK: Textfield delegates
extension VerifyAadharViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else {
            return true }
        
        if textField.text?.count ?? 0 <= 13 {
            textField.text = textField.text?.formatAadharWithSpace()
            return true
        } else {
            return false
        }
    }
}

// MARK: Display logic
extension VerifyAadharViewController: VerifyAadharDisplayLogic {
    
    // MARK: Display Something
    func displaySomething(viewModel: VerifyAadhar.Something.ViewModel) {
        // nameTextField.text = viewModel.name
    }
}
