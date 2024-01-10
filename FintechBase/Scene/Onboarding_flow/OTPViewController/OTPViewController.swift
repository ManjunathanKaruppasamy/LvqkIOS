//
//  OTPViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol OTPDisplayLogic: AnyObject {
    func displayOTPResponse(viewModel: OTP.OTPModel.ViewModel)
    func displayValidateOTP(viewModel: OTP.OTPModel.ViewModel)
    func presentMobileNumber(otpUIData: OTPUIData)
    func updateCount(totalTime: String)
    func displayEmptyOtpResponse(isValid: Bool)
}

class OTPViewController: UIViewController {
    var interactor: OTPBusinessLogic?
    var router: (NSObjectProtocol & OTPRoutingLogic & OTPDataPassing)?
    
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var tittleLbl: UILabel?
    @IBOutlet weak var staticDescriptionLbl: UILabel?
    @IBOutlet weak var verifyBttn: UIButton?
    @IBOutlet weak var mobileLabel: UILabel?
    @IBOutlet weak var otpFieldView: M2PPinView?
    @IBOutlet weak var otpFieldHeight: NSLayoutConstraint?
    @IBOutlet weak var resendLabel: UILabel?
    @IBOutlet weak var notReceiveLbl: UILabel?
    @IBOutlet weak var cancelButton: UIButton?
    
    var mobileNumber = ""
    var isFromForgot: Bool = false
    var isFromAccountClose: Bool = false
    var verifyOTPTapped: ((_ otpString: String, _ showSuccessPopUp: Bool) -> Void)?
    var enteredOTP = "$$$$$$"
    private var isErrorApplied: Bool = false
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.interactor?.startTimer()
//        self.setupMpinView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.interactor?.stopTimer()
    }
    
}

// MARK: Initial Set Up
extension OTPViewController {
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setAction()
        self.setColor()
        self.setFont()
        self.setupMpinView()
        self.interactor?.getMobileNumber()
        self.interactor?.getOTP()
    }
    
    // MARK: Color
    private func setColor() {
        self.tittleLbl?.textColor = .primaryColor
        self.staticDescriptionLbl?.textColor = .darkGreyDescriptionColor
        self.mobileLabel?.textColor = .primaryColor
        self.resendLabel?.textColor = .darkGreyDescriptionColor
        self.notReceiveLbl?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        self.tittleLbl?.font = UIFont.setCustomFont(name: .regular, size: .x24)
        self.staticDescriptionLbl?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        self.mobileLabel?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        self.notReceiveLbl?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.resendLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
    }
    
    // MARK: Static Text
    private func setStaticText(number: String) {
        self.notReceiveLbl?.text = AppLoacalize.textString.notReceiveOTP
        self.staticDescriptionLbl?.text = AppLoacalize.textString.otpDescription
        if self.isFromForgot {
            self.tittleLbl?.text = AppLoacalize.textString.forgotMpinOtptitle
            self.mobileLabel?.text = "\(AppLoacalize.textString.countryCode) \(number)"
            self.cancelButton?.isHidden = false
        } else if self.isFromAccountClose {
            self.tittleLbl?.text = AppLoacalize.textString.otptitle
            self.staticDescriptionLbl?.text = AppLoacalize.textString.otpDescription
            self.mobileLabel?.text = "\(AppLoacalize.textString.countryCode) \(number)"
            self.cancelButton?.isHidden = false
        } else {
            self.tittleLbl?.text = AppLoacalize.textString.otptitle
            self.staticDescriptionLbl?.text = AppLoacalize.textString.otpDescription
            
            let mobileLabelAttributedString = NSMutableAttributedString(string: "\(AppLoacalize.textString.countryCode) \(number) Change")
            mobileLabelAttributedString.applyUnderLineText(subString: "Change")
            self.mobileLabel?.attributedText = mobileLabelAttributedString
            self.cancelButton?.isHidden = true
        }
    }
    
    // MARK: Set Action
    private func setAction() {
        self.verifyBttn?.setup(title: AppLoacalize.textString.verifyOTP, type: .primary, isEnabled: false)
        self.verifyBttn?.addTarget(self, action: #selector(verifyBttnAction(_:)), for: .touchUpInside)
        
        let mobileLabelTapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapChange(gesture:)))
        mobileLabel?.isUserInteractionEnabled = true
        mobileLabel?.addGestureRecognizer(mobileLabelTapAction)
        
        let resendLabelTapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapResend(gesture:)))
        resendLabel?.addGestureRecognizer(resendLabelTapAction)
        self.cancelButton?.setup(title: AppLoacalize.textString.cancel, type: .skip, skipButtonFont: UIFont.setCustomFont(name: .regular, size: .x16))
        self.cancelButton?.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Cancel Button Action
    @objc private func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
        
    // MARK: Tap Change Action
    @objc func tapChange(gesture: UITapGestureRecognizer) {
        guard let mobileLabel = mobileLabel else {
            return
        }
        if gesture.didTapAttributedString("Change", in: mobileLabel) {
            self.dismiss(animated: true)
        }
    }
    
    // MARK: Tap Resend Action
    @objc func tapResend(gesture: UITapGestureRecognizer) {
        guard let mobileLabel = resendLabel else {
            return
        }
        if gesture.didTapAttributedString("Resend", in: mobileLabel) {
            self.resetOtpView()
            self.interactor?.startTimer()
            otpFieldView?.setBecomeFirstResponder = {
                    _ = self.otpFieldView?.becomeFirstResponder()
            }
            self.interactor?.getOTP()
        }
    }
    
    // MARK: Verify Button Action
    @objc private func verifyBttnAction(_ sender: UIButton) {
        self.interactor?.getValidateOTP(otp: self.enteredOTP)
    }
    
    // MARK: Setup MpinView
    private func setupMpinView() {
        [otpFieldView].forEach {
            $0?.count = 6
            $0?.fontTextField = UIFont.setCustomFont(name: .regular, size: .x18)
            $0?.isBottomLineTextField = true
            $0?.borderColorTextField = .blusihGryColor
            $0?.borderWidthTextField = 1
            $0?.selectedBorderColorTextField = .blusihGryColor
            $0?.selectedBorderWidthTextField = 1
            $0?.tintColorTextField = .black
            $0?.textColorTextField = .blackTextColor
            $0?.type = .enterMpin
            $0?.dismissOnLastEntry = true
        }
        
        otpFieldView?.setBecomeFirstResponder = {
                _ = self.otpFieldView?.becomeFirstResponder()
        }
        self.createMpinViewCallBack()
    }
    
    // MARK: Handle CreateMpinView CallBack
    private func createMpinViewCallBack() {
        otpFieldView?.mPinData = { (text, index) in // Create MPIN Data
            let newIndex = index/1000 - 1
            if self.isErrorApplied {
                self.resetOtpView()
            }
            self.enteredOTP = self.replace(oldString: self.enteredOTP, newIndex, Character(text))
            self.interactor?.emptyOtpCheck(otp: self.enteredOTP)
        }
        
        otpFieldView?.mpinEndData = { (text, index) in // End Action for Create MPIN
            let newIndex = index/1000 - 1
            self.enteredOTP = self.replace(oldString: self.enteredOTP, newIndex, Character(text))
            _ = self.otpFieldView?.resignFirstResponder()
            self.interactor?.emptyOtpCheck(otp: self.enteredOTP)
        }
        
        otpFieldView?.isBackspaceClicked = {
            if self.isErrorApplied {
                self.resetOtpView()
            }
            self.verifyBttn?.setPrimaryButtonState(isEnabled: false)
        }
    }
    
    // MARK: Replace New Pin
    private func replace(oldString: String, _ index: Int, _ newCharacter: Character) -> String {
        var characters = Array(oldString)
        characters[index] = newCharacter
        let modifiedString = String(characters)
        return modifiedString
    }
    
    // MARK: Reset View After Failure
    private func resetOtpView() {
        _ = self.otpFieldView?.becomeFirstResponder()
        self.otpFieldView?.text = ""
        self.enteredOTP = "$$$$$$"
        self.isErrorApplied = false
        self.otpFieldView?.resetErrorBorder()
    }
    
    // MARK: Show Error View
    private func showErrorOtpView() {
        self.isErrorApplied = true
        otpFieldView?.setErrorBorder()
    }
}

// MARK: Display logic
extension OTPViewController: OTPDisplayLogic {
    // MARK: Get OTP Response
    func displayOTPResponse(viewModel: OTP.OTPModel.ViewModel) {
        if viewModel.getOTPViewModel?.status != APIStatus.statusString.success {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
        }
    }
    // MARK: Validate OTP Response
    func displayValidateOTP(viewModel: OTP.OTPModel.ViewModel) {
        if viewModel.validateOTPViewModel?.status == APIStatus.statusString.success {
            ACCESSTOKEN = viewModel.validateOTPViewModel?.accessToken ?? ""
            REFRESHTOKEN = viewModel.validateOTPViewModel?.refreshToken ?? ""
            userMobileNumber = self.mobileNumber
            self.router?.routeToNextVC(isFromForgot: self.isFromForgot)
        } else if viewModel.validateOTPViewModel?.status == APIStatus.statusString.failed {
            showSuccessToastMessage(message: AppLoacalize.textString.incorrectOTP, messageColor: .white, bgColour: UIColor.redErrorColor)
            self.showErrorOtpView()
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
        }
        
    }
    // MARK: Update Initial Data
    func presentMobileNumber(otpUIData: OTPUIData) {
        self.isFromAccountClose = otpUIData.isFromAccountClose ?? false
        self.isFromForgot = otpUIData.isFromForgot ?? false
        self.mobileNumber = otpUIData.number ?? ""
        self.setStaticText(number: self.mobileNumber)
    }
    
    // MARK: Update Timer Count
    func updateCount(totalTime: String) {
        
        let resendLabelString = NSMutableAttributedString(string: "Resend in \(totalTime)")
        resendLabelString.apply(color: UIColor.blusihGryColor, subString: "Resend", textFont: .setCustomFont(name: .regular, size: .x14))
        self.resendLabel?.attributedText = resendLabelString
        
        if totalTime == "00:00" {
            let resendLabelAttributedString = NSMutableAttributedString(string: "Resend")
            resendLabelAttributedString.applyUnderLineText(subString: "Resend")
            self.resendLabel?.attributedText = resendLabelAttributedString
            self.resendLabel?.isUserInteractionEnabled = true
        } else {
            self.resendLabel?.isUserInteractionEnabled = false
        }
    }
    
    // MARK: Display Empty otp response
    func displayEmptyOtpResponse(isValid: Bool) {
        verifyBttn?.setPrimaryButtonState(isEnabled: isValid)
    }
}
