//
//  VerifyOTPViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol VerifyOTPDisplayLogic: AnyObject {
    func displayTimerCount(timerCount: String)
    func displayUIAttributes(flowEnum: ModuleFlowEnum)
    func displayGenerateOTPResponse(viewModel: VerifyOTP.OTPModel.ViewModel)
    func displayValidateOTP(viewModel: VerifyOTP.OTPModel.ViewModel)
    func displayEmptyOtpResponse(isValid: Bool)
    func displayUpdateEmailResponse(response: MPINResponseData?)
}

class VerifyOTPViewController: UIViewController {
    @IBOutlet private weak var statusBarView: UIView?
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var navigationTitleLabel: UILabel?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descLabel: UILabel?
    @IBOutlet private weak var cardView: UIView?
    @IBOutlet private weak var otpViewTitleLabel: UILabel?
    @IBOutlet private weak var otpView: M2PPinView?
    @IBOutlet private weak var otpNotRcvLabel: UILabel?
    @IBOutlet private weak var timerLabel: UILabel?
    @IBOutlet private weak var resendButton: UIButton?
    @IBOutlet private weak var verifyButton: UIButton?
    @IBOutlet private weak var checkBoxButton: UIButton?
    @IBOutlet private weak var termsLabel: UILabel?
    @IBOutlet private weak var termsAndConditionsView: UIView?
    
  var interactor: VerifyOTPBusinessLogic?
  var router: (NSObjectProtocol & VerifyOTPRoutingLogic & VerifyOTPDataPassing)?
  private var enteredOTP = "$$$$$$"
  private var isErrorApplied = false
  private var flowEnum: ModuleFlowEnum = .none
  
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
      interactor?.getUIAttributes()
      self.generateOtpResponse()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationView?.applyGradient(isVertical: true, colorArray: [.statusBarColor, .appDarkBlueColor])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.interactor?.stopTimer()
    }
}

// MARK: Initial Setup
extension VerifyOTPViewController {
    
    // MARK: Initial UI loads
      private func initializeUI() {
          [navigationTitleLabel].forEach {
              $0?.textColor = .white
              $0?.font = .setCustomFont(name: .semiBold, size: .x18)
              $0?.text = flowEnum == .updateEmail ? AppLoacalize.textString.emailSettings : AppLoacalize.textString.resetMpin
          }
          [titleLabel].forEach {
              $0?.textColor = .primaryColor
              $0?.font = .setCustomFont(name: .regular, size: .x18)
              $0?.text = flowEnum == .updateEmail ? AppLoacalize.textString.changeEmailID : AppLoacalize.textString.enterOTP
          }
          [otpViewTitleLabel, otpNotRcvLabel, descLabel, timerLabel].forEach {
              $0?.textColor = .darkGreyDescriptionColor
              $0?.font = .setCustomFont(name: .regular, size: .x14)
              $0?.numberOfLines = 0
              otpViewTitleLabel?.isHidden = flowEnum == .resetMpin
          }
          [termsLabel].forEach {
              $0?.font = .setCustomFont(name: .regular, size: .x12)
              $0?.text = AppLoacalize.textString.terms
          }
          [cardView].forEach {
              $0?.addLightShadow(radius: 16)
              $0?.backgroundColor = .white
          }
          [resendButton].forEach {
              $0?.setTitle("\(AppLoacalize.textString.resend)?", for: .normal)
              $0?.setTitleColor(.hyperLinK, for: .normal)
              $0?.titleLabel?.font = .setCustomFont(name: .regular, size: .x16)
              $0?.isHidden = true
          }
          termsAndConditionsView?.isHidden = true
          navigationSetup()
          setStaticTextTitles()
          initializeBtnActions()
          enableTermsAndConditionButton(enable: false)
          enableVerifyBtn(enable: false)
      }
    
    // MARK: NavigationSetup
    private func navigationSetup() {
        statusBarView?.backgroundColor = .statusBarColor
        view.backgroundColor = .whitebackgroundColor
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Set StaticText Titles
    private func setStaticTextTitles() {
        otpNotRcvLabel?.text = AppLoacalize.textString.notReceiveOTP
        otpViewTitleLabel?.text = AppLoacalize.textString.enterOTP
        
        descLabel?.text = AppLoacalize.textString.otpForResetMpin + " " + (flowEnum == .updateEmail ? userMobileNumber : userMobileNumber.formatMobileNumber()) + ", " + AppLoacalize.textString.toVerifyItsYou
        
    }
    
    // MARK: Initialize Btn Actions
    private func initializeBtnActions() {
        backButton?.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        resendButton?.addTarget(self, action: #selector(resendBtnAction), for: .touchUpInside)
        verifyButton?.addTarget(self, action: #selector(verifyBtnAction), for: .touchUpInside)
        checkBoxButton?.addTarget(self, action: #selector(checkBoxAction), for: .touchUpInside)
        timerLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendBtnAction)))
    }
    
    // MARK: Setup MpinView
    private func setupMpinView() {
        [otpView].forEach {
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
        
        self.otpView?.setBecomeFirstResponder = {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                _ = self.otpView?.becomeFirstResponder()
            }
        }
        self.createMpinViewCallBack()
    }
    
    // MARK: Handle CreateMpinView CallBack
    private func createMpinViewCallBack() {
        otpView?.mPinData = { (text, index) in // Create MPIN Data
            let newIndex = index/1000 - 1
            if self.isErrorApplied {
                self.resetOtpView()
            }
            self.enteredOTP = self.replace(oldString: self.enteredOTP, newIndex, Character(text))
            self.interactor?.emptyOtpCheck(otp: self.enteredOTP)
        }
        
        otpView?.mpinEndData = { (text, index) in // End Action for Create MPIN
            let newIndex = index/1000 - 1
            self.enteredOTP = self.replace(oldString: self.enteredOTP, newIndex, Character(text))
            _ = self.otpView?.resignFirstResponder()
            self.interactor?.emptyOtpCheck(otp: self.enteredOTP)
        }
        
        otpView?.isBackspaceClicked = {
            if self.isErrorApplied {
                self.resetOtpView()
            }
            self.verifyButton?.setPrimaryButtonState(isEnabled: false)
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
        _ = self.otpView?.becomeFirstResponder()
        self.otpView?.text = ""
        self.enteredOTP = "$$$$$$"
        self.isErrorApplied = false
        self.otpView?.resetErrorBorder()
    }
    
    // MARK: Show Error View
    private func showErrorOtpView() {
        self.isErrorApplied = true
        otpView?.setErrorBorder()
    }
    
}

// MARK: Button actions
extension VerifyOTPViewController {
    
    // MARK: Back action
    @objc private func backBtnAction() {
        if flowEnum == .updateEmail {
            self.popToViewController(destination: TabbarViewController.self)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Resend Btn action
    @objc private func resendBtnAction( gesture: UITapGestureRecognizer) {
        guard let uiObject = timerLabel else {
            return
        }
        if gesture.didTapAttributedString( AppLoacalize.textString.resend, in: uiObject) {
            resetOtpView()
            self.interactor?.startTimer()
            self.generateOtpResponse()
            otpView?.setBecomeFirstResponder = {
                _ = self.otpView?.becomeFirstResponder()
            }
            verifyButton?.setPrimaryButtonState(isEnabled: false)
        }
    }
    
    // MARK: VerifyBtn actions
    @objc private func verifyBtnAction() {
        interactor?.getValidateOTP(otp: enteredOTP)
    }
    
    // MARK: CheckBoxBtn actions
    @objc private func checkBoxAction() {
        enableTermsAndConditionButton(enable: !(checkBoxButton?.isSelected ?? false))
    }
}

// MARK: Routing
extension VerifyOTPViewController {
    private func moveToRequiredVC(flowEnum: ModuleFlowEnum) {
        if flowEnum == .updateEmail {
            self.interactor?.updateEmail()
        } else if flowEnum == .resetMpin {
            self.router?.routeToResetMpinVC()
        }
    }
}

// MARK: Interacter Requests
extension VerifyOTPViewController {
    /* Start Timer */
    private func startTimer() {
        interactor?.startTimer()
    }
    
    /* Generate Otp Response */
    private func generateOtpResponse() {
        interactor?.genrerateOTP()
    }
}

// MARK: Enable & Disable Actions
extension VerifyOTPViewController {
    
    // MARK: CheckBox Button logic
    private func enableTermsAndConditionButton(enable: Bool) {
        termsLabel?.textColor =  enable ? .primaryColor : .gray2
        checkBoxButton?.isSelected = enable
        checkBoxButton?.tintColor = .clear
        enable ? checkBoxButton?.setBackgroundImage(UIImage(named: Image.imageString.fillcheckBox), for: .selected) :
        checkBoxButton?.setBackgroundImage(UIImage(named: Image.imageString.checkBox), for: .normal)
    }
    
    // MARK: Verify Button logic
    private func enableVerifyBtn(enable: Bool) {
        verifyButton?.setup(title: flowEnum == .updateEmail ? AppLoacalize.textString.continueText : AppLoacalize.textString.verifyOTP, type: .primary, isEnabled: enable)
        verifyButton?.tintColor = .clear
    }
}

// MARK: Display Logic
extension VerifyOTPViewController: VerifyOTPDisplayLogic {
   
    /* Display Timer Count */
    func displayTimerCount(timerCount: String) {
        let resendLabelString = NSMutableAttributedString(string: "Resend in \(timerCount)")
        resendLabelString.apply(color: UIColor.blusihGryColor, subString: AppLoacalize.textString.resend, textFont: .setCustomFont(name: .regular, size: .x14))
        self.timerLabel?.attributedText = resendLabelString
        
        if timerCount == "00:00" {
            let resendLabelAttributedString = NSMutableAttributedString(string: AppLoacalize.textString.resend)
            resendLabelAttributedString.applyUnderLineText(subString: AppLoacalize.textString.resend)
            self.timerLabel?.attributedText = resendLabelAttributedString
            self.timerLabel?.isUserInteractionEnabled = true
        } else {
            self.timerLabel?.isUserInteractionEnabled = false
        }
    }
    
    /* Display UI Attributes */
    func displayUIAttributes(flowEnum: ModuleFlowEnum) {
        self.flowEnum = flowEnum
        initializeUI()
        self.setupMpinView()
        startTimer()
    }
    
    // MARK: Get Generate OTP Response
    func displayGenerateOTPResponse(viewModel: VerifyOTP.OTPModel.ViewModel) {
        if viewModel.getOTPViewModel?.status != APIStatus.statusString.success {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
        }
    }
    
    // MARK: Validate OTP Response
    func displayValidateOTP(viewModel: VerifyOTP.OTPModel.ViewModel) {
        if viewModel.validateOTPViewModel?.status == APIStatus.statusString.success {
            ACCESSTOKEN = viewModel.validateOTPViewModel?.accessToken ?? ""
            REFRESHTOKEN = viewModel.validateOTPViewModel?.refreshToken ?? ""
            self.moveToRequiredVC(flowEnum: self.flowEnum)
        } else if viewModel.validateOTPViewModel?.status == APIStatus.statusString.failed {
            showSuccessToastMessage(message: AppLoacalize.textString.incorrectOTP, messageColor: .white, bgColour: UIColor.redErrorColor)
            self.showErrorOtpView()
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
        }
    }
    
    // MARK: Empty OTP Response
    func displayEmptyOtpResponse(isValid: Bool) {
        verifyButton?.setPrimaryButtonState(isEnabled: isValid)
    }
    
    /* Display Update Email Confirmation */
    func displayUpdateEmailResponse(response: MPINResponseData?) {
        if let responseData = response, responseData.status == APIStatus.statusString.success {
            showSuccessToastMessage(message: AppLoacalize.textString.emailUpdateSuccess, messageColor: .white, bgColour: .greenTextColor, position: .betweenBottomAndCenter)
            self.popToViewController(destination: TabbarViewController.self)
        } else {
            showSuccessToastMessage(message: response?.status ?? AppLoacalize.textString.somethingWentWrong)
        }
    }
}
