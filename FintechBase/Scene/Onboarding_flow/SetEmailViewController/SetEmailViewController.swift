//
//  SetEmailViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SetEmailDisplayLogic: AnyObject {
    func displaySomething(viewModel: SetEmail.Something.ViewModel)
}
protocol PassEmailValueDelegate {
    func passEmailValue(title: String, email: String)
}
class SetEmailViewController: UIViewController {
    var interactor: SetEmailBusinessLogic?
    var router: (NSObjectProtocol & SetEmailRoutingLogic & SetEmailDataPassing)?

    @IBOutlet private weak var submitButton: UIButton?
    @IBOutlet private weak var viewContent: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    
    @IBOutlet private weak var userTitleLabel: UILabel?
    @IBOutlet private weak var mrButton: UIButton?
    @IBOutlet private weak var msButton: UIButton?
    @IBOutlet private weak var mrsButton: UIButton?
    
    @IBOutlet private weak var nameTItleLabel: UILabel?
    @IBOutlet private weak var userNameLabel: UILabel?
    @IBOutlet private weak var userPrefixLabel: UILabel?
    @IBOutlet private weak var emailTextfieldView: CustomFloatingTextField?
    
    var email = ""
    var passEmailValueDelegate: PassEmailValueDelegate?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.applyCrossDissolvePresentAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - Initial Setup
extension SetEmailViewController {
    /* Initial loads */
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.viewContent?.layer.cornerRadius = 16
        self.setAction()
        self.setColor()
        self.setFont()
        self.setStaticText()
        self.setEmaiTextfieldView()
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
        self.userTitleLabel?.textColor = .midGreyColor
        self.nameTItleLabel?.textColor = .midGreyColor
        self.userNameLabel?.textColor = .primaryColor
        self.userPrefixLabel?.textColor = .primaryColor
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.userTitleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.nameTItleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.userNameLabel?.font = UIFont.setCustomFont(name: .regular, size: .x18)
        self.userPrefixLabel?.font = UIFont.setCustomFont(name: .regular, size: .x18)
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.titleLabel?.text = AppLoacalize.textString.setEmailTitle
        self.userTitleLabel?.text = AppLoacalize.textString.title
        self.nameTItleLabel?.text = AppLoacalize.textString.name
        self.mrButton?.setTitle(AppLoacalize.textString.mister, for: .normal)
        self.msButton?.setTitle(AppLoacalize.textString.miss, for: .normal)
        self.mrsButton?.setTitle(AppLoacalize.textString.misters, for: .normal)
        self.userNameLabel?.text = userName
        self.userPrefixLabel?.text = AppLoacalize.textString.mister
    }
    
    private func setEmaiTextfieldView() {
        self.emailTextfieldView?.contentTextfield?.titleFont = UIFont.setCustomFont(name: .regular, size: .x12)
        self.emailTextfieldView?.contentTextfield?.placeholderFont = UIFont.setCustomFont(name: .regular, size: .x18)
        self.emailTextfieldView?.contentTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x18)
        self.emailTextfieldView?.contentTextfield?.titleColor = .midGreyColor
        self.emailTextfieldView?.contentTextfield?.selectedTitleColor = .midGreyColor
        self.emailTextfieldView?.contentTextfield?.autocorrectionType = .no
        self.emailTextfieldView?.setupField(selectType: .text, title: AppLoacalize.textString.enterEmailAddress, placeHolder: AppLoacalize.textString.enterEmailAddress, errorDescription: ErrorAndDescription(type: .withDescription, description: AppLoacalize.textString.enterEmailAddressDescription))
        self.emailTextfieldView?.contentTextfield?.textColor = .primaryColor
        self.emailTextfieldView?.onClearOptions = {
            self.submitButton?.setPrimaryButtonState(isEnabled: false)
        }
        self.emailTextfieldView?.checkAtEndEdit = { endEditing in
            self.email = self.emailTextfieldView?.contentTextfield?.text ?? ""
            self.checkEmptyField()
        }
    }
    
    private func checkEmptyField() {
        if self.email.isEmpty {
            self.submitButton?.setPrimaryButtonState(isEnabled: false)
        } else {
            if self.email.isValidEmail() {
                self.submitButton?.setPrimaryButtonState(isEnabled: true)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.invalidEmail, position: .bottom)
                self.submitButton?.setPrimaryButtonState(isEnabled: false)
            }
            
        }
    }
    
    // MARK: Set Action
    private func setAction() {
        self.submitButton?.setup(title: AppLoacalize.textString.submit, type: .primary, isEnabled: false)
        self.submitButton?.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
        self.mrButton?.tag = 1
        self.msButton?.tag = 2
        self.mrsButton?.tag = 3
        self.mrButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
        [self.mrButton, self.msButton, self.mrsButton].forEach {
            $0?.addTarget(self, action: #selector(titleButtonAction(_:)), for: .touchUpInside)
            if $0?.tag == 1 {
                $0?.setTitleColor(.primaryButtonColor, for: .normal)
                $0?.tintColor = .primaryButtonColor
            } else {
                $0?.setTitleColor(.midGreyColor, for: .normal)
                $0?.tintColor = .midGreyColor
            }
        }
    }
    
    // MARK: Submit Button Action
    @objc private func submitButtonAction(_ sender: UIButton) {
//        self.dismiss(animated: true) {
            let title = self.userPrefixLabel?.text ?? ""
            self.passEmailValueDelegate?.passEmailValue(title: title == "Mrs." ? "Mrs" : title, email: self.email)
//        }
    }
    
    // MARK: User Title Button Action
    @objc private func titleButtonAction(_ sender: UIButton) {
        [self.mrButton, self.msButton, self.mrsButton].forEach {
            if $0?.tag == sender.tag {
                $0?.setTitleColor(.primaryButtonColor, for: .normal)
                $0?.tintColor = .primaryButtonColor
                $0?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
            } else {
                $0?.setTitleColor(.midGreyColor, for: .normal)
                $0?.tintColor = .midGreyColor
                $0?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
            }
        }
        switch sender.tag {
        case 1:
            self.userPrefixLabel?.text = AppLoacalize.textString.mister
        case 2:
            self.userPrefixLabel?.text = AppLoacalize.textString.miss
        case 3:
            self.userPrefixLabel?.text = AppLoacalize.textString.misters
        default:
            print("nil")
        }
        checkEmptyField()
    }
}

// MARK: - <SetEmailDisplayLogic> Methods
extension SetEmailViewController: SetEmailDisplayLogic {
    func displaySomething(viewModel: SetEmail.Something.ViewModel) {
        // nameTextField.text = viewModel.name
    }
}
