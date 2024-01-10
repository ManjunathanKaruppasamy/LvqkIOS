//
//  ForgotMPINViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol ForgotMPINDisplayLogic: AnyObject {
    func displayForgotMPINResponse(viewModel: ForgotMPIN.ForgotMPINModel.ViewModel)
}

class ForgotMPINViewController: UIViewController {
    var interactor: ForgotMPINBusinessLogic?
    var router: (NSObjectProtocol & ForgotMPINRoutingLogic & ForgotMPINDataPassing)?
    
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var dobTextfieldView: CustomFloatingTextField?
    @IBOutlet weak var proceedButton: UIButton?
    @IBOutlet weak var descriptionLbl: UILabel?
    @IBOutlet weak var cancelButton: UIButton?
    
    var selectedDate = ""
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}

// MARK: Initial Set Up
extension ForgotMPINViewController {
    /* Initial Loads */
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setDobTextfieldView()
        self.setButton()
        self.setColor()
        self.setFont()
        self.setStaticText()
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLbl?.textColor = .primaryColor
        self.descriptionLbl?.textColor = .darkGreyDescriptionColor
        
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLbl?.font = UIFont.setCustomFont(name: .regular, size: .x24)
        self.descriptionLbl?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.titleLbl?.text = AppLoacalize.textString.forgotMPIN
        self.descriptionLbl?.text = AppLoacalize.textString.forgotMpinDescription
    }
    
    // MARK: Set DobTextfield View
    private func setDobTextfieldView() {
        self.dobTextfieldView?.setupField(selectType: .customeCalender, title: AppLoacalize.textString.dateOfBirth, placeHolder: AppLoacalize.textString.ddmmyyyy)
        self.dobTextfieldView?.contentTextfield?.text = AppLoacalize.textString.ddmmyyyy
        self.dobTextfieldView?.contentTextfield?.textColor = .lightDisableBackgroundColor
        
        self.dobTextfieldView?.onClickCustomAction = {
            self.presentCalendar()
        }
    }
    
    /* Present Date Picker */
    private func presentCalendar() {
        let selectedDate = self.getDateFromString(dateString: self.selectedDate)
        let viewHeight = self.view.frame.height
        M2PDatePicker.shared.m2pAddDatePicker(backGroundColor: .white, textColor: .black, maxDate: Date(), selectedDate: selectedDate, height: (viewHeight/3))
        
        M2PDatePicker.shared.getSelectedDate = { [weak self] date in
            self?.view.endEditing(true)
            let dateValue = self?.getStringFromDate(date: date ?? Date()) ?? ""
            self?.dobTextfieldView?.hideErrorMessage()
            self?.dobTextfieldView?.contentTextfield?.textColor = .primaryColor
            self?.dobTextfieldView?.contentTextfield?.text = dateValue
            self?.selectedDate = dateValue
            if !dateValue.isEmpty {
                self?.proceedButton?.setPrimaryButtonState(isEnabled: true)
                
            }
        }
    }
    
    // MARK: Set Button
    private func setButton() {
        self.proceedButton?.setup(title: AppLoacalize.textString.proceed, type: .primary, isEnabled: false)
        self.proceedButton?.addTarget(self, action: #selector(proceedButtonAction(_:)), for: .touchUpInside)
        self.cancelButton?.setup(title: AppLoacalize.textString.cancel, type: .skip, skipButtonFont: UIFont.setCustomFont(name: .regular, size: .x16))
        self.cancelButton?.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Cancel Button Action
    @objc private func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
        
    // MARK: Proceed Button Action
    @objc private func proceedButtonAction(_ sender: UIButton) {
        let request = ForgotMPIN.ForgotMPINModel.Request(forgotMPINRequest: ForgotMPINRequest(mobile: userMobileNumber, dob: self.selectedDate ))
        self.interactor?.getForgotMPINResponse(request: request)
    }
}

// MARK: Display Logic
extension ForgotMPINViewController: ForgotMPINDisplayLogic {
    /* Display ForgotMPIN Response */
    func displayForgotMPINResponse(viewModel: ForgotMPIN.ForgotMPINModel.ViewModel) {
        switch viewModel.viewModel?.status {
        case CustomerStatus.success.rawValue:
            self.router?.routeToOTPController()
        case CustomerStatus.failed.rawValue:
            self.proceedButton?.setPrimaryButtonState(isEnabled: false)
            if viewModel.viewModel?.error == "Invalid dob" {
                showSuccessToastMessage(message: AppLoacalize.textString.incorrectDob)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
//            self.router?.routeToOTPController()
        default:
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
        }
    }
    
}
