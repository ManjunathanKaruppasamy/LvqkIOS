//
//  AccountClosureViewController.swift
//  FintechBase
//
//  Created by Sravani Madala on 26/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AccountClosureDisplayLogic: AnyObject {
    func displayRequestCallBackresponse(response: AccountClosure.AccountModel.ViewModel)
}

class AccountClosureViewController: UIViewController {
    var interactor: AccountClosureBusinessLogic?
    var router: (NSObjectProtocol & AccountClosureRoutingLogic & AccountClosureDataPassing)?

    @IBOutlet private weak var customView: UIView?
    @IBOutlet private weak var closeButton: UIButton?
    @IBOutlet private weak var closeOtherButton: UIButton?
    @IBOutlet private weak var topImage: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var requestCallButton: UIButton?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var continueClosureButton: UIButton?
    @IBOutlet private weak var callRequestView: UIView?
    @IBOutlet private weak var callCloseButton: UIButton?
    @IBOutlet private weak var callTopImage: UIImageView?
    @IBOutlet private weak var calltTitleLabel: UILabel?
    @IBOutlet private weak var gotItButton: UIButton?
    @IBOutlet private weak var sadToSeeCustomView: UIView?
    @IBOutlet private weak var callDescriptionLabel: UILabel?
    @IBOutlet private weak var sadToSeeLabel: UILabel?
    @IBOutlet private weak var sadToSeeDescLabel: UILabel?
    @IBOutlet private weak var sadToSeeDescLabel2: UILabel?
    
    @IBOutlet private weak var confirmClosureCustomView: UIView?
    @IBOutlet private weak var noChangeButton: UIButton?
    @IBOutlet private weak var closeAccountButton: UIButton?
    @IBOutlet private weak var areSureDescLabel: UILabel?
    @IBOutlet private weak var sadEmojiImage: UIImageView?
    
    var onClickClose: ((Bool) -> Void)?
    var onClickClosureAction: ((Bool) -> Void)?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.applyCrossDissolvePresentAnimation()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.applyCrossDissolvePresentAnimation()
    }
}

// MARK: - Initial Setup
extension AccountClosureViewController {
    private func initialLoad() {
        setFont()
        setColor()
        setButton()
        setLocalization()
        self.customView?.setCornerRadius(radius: 16)
        self.callRequestView?.setCornerRadius(radius: 16)
        self.confirmClosureCustomView?.setCornerRadius(radius: 16)
        
        self.callRequestView?.isHidden = true
        self.confirmClosureCustomView?.isHidden = true
        self.sadToSeeCustomView?.isHidden = true
        self.sadEmojiImage?.isHidden = true
    }
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .textBlackColor
        self.descriptionLabel?.textColor = .darkGreyDescriptionColor
        self.calltTitleLabel?.textColor = .textBlackColor
        self.callDescriptionLabel?.textColor = .darkGreyDescriptionColor
        self.sadToSeeDescLabel?.textColor = .midGreyColor
        self.sadToSeeDescLabel2?.textColor = .midGreyColor
        self.sadToSeeLabel?.textColor = .primaryColor
        self.areSureDescLabel?.textColor = .textBlackColor
    }
    
    // MARK: Set Localization
    private func setLocalization() {
        let descriptionLabelString = NSMutableAttributedString(string: AppLoacalize.textString.whatWentWrongDesc)
        descriptionLabelString.apply(color: UIColor.textBlackColor, subString: "18003092225", textFont: .setCustomFont(name: .regular, size: .x14))
        descriptionLabelString.apply(color: UIColor.textBlackColor, subString: "\("Request for call back")", textFont: .setCustomFont(name: .regular, size: .x14))
        self.descriptionLabel?.attributedText = descriptionLabelString
        self.sadToSeeDescLabel?.text = AppLoacalize.textString.closingAccountDesc
        self.sadToSeeDescLabel2?.text = AppLoacalize.textString.closingAccountDescs2
        self.sadToSeeLabel?.text = AppLoacalize.textString.sadToSeeTitle
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.calltTitleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.callDescriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.areSureDescLabel?.font = UIFont.setCustomFont(name: .regular, size: .x18)
        self.sadToSeeLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.sadToSeeDescLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.sadToSeeDescLabel2?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.calltTitleLabel?.text = AppLoacalize.textString.requestAccepted
        self.callDescriptionLabel?.text = AppLoacalize.textString.callRequestDesc
        
    }
    // MARK: set Button
    private func setButton() {
        self.requestCallButton?.setup(title: AppLoacalize.textString.requestCallForBreak, type: .primary, isEnabled: true)
        self.continueClosureButton?.setup(title: AppLoacalize.textString.continueForClosure, type: .skip, isEnabled: true, skipButtonFont: .setCustomFont(name: .regular, size: .x16))
        self.gotItButton?.setup(title: AppLoacalize.textString.gotIt, type: .primary, isEnabled: true)
        self.requestCallButton?.setup(title: AppLoacalize.textString.requestCallForBreak, type: .primary, isEnabled: true)
        self.noChangeButton?.setup(title: AppLoacalize.textString.noIchangeButton, type: .primary, isEnabled: true)
        self.closeAccountButton?.setup(title: AppLoacalize.textString.yesIWantToClose, type: .skip, isEnabled: true, skipButtonFont: .setCustomFont(name: .regular, size: .x16))
        self.requestCallButton?.addTarget(self, action: #selector(requestCallButtonAction(_:)), for: .touchUpInside)
        self.continueClosureButton?.addTarget(self, action: #selector(continueForClosureAction(_:)), for: .touchUpInside)
        self.closeButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        self.closeOtherButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        self.callCloseButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        self.gotItButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        self.noChangeButton?.addTarget(self, action: #selector(cancelAccountClosureAction(_:)), for: .touchUpInside)
        self.closeAccountButton?.addTarget(self, action: #selector(accountClosureAction(_:)), for: .touchUpInside)
    }
}

// MARK: Button Actions
extension AccountClosureViewController {
    // MARK: request call Button Action
    @objc private func requestCallButtonAction(_ sender: UIButton) {
        self.interactor?.fetchRequestCallBackApi()
    }
    
    // MARK: Cloure Button Action
    @objc private func continueForClosureAction(_ sender: UIButton) {
       // self.view.applyCrossDissolveDismissAnimation(handler: { isExecuted in
           // if isExecuted {
                self.view.backgroundColor = .plainBGColor
                self.customView?.isHidden = true
                self.callRequestView?.isHidden = true
                self.sadToSeeCustomView?.isHidden = false
                self.confirmClosureCustomView?.isHidden = false
                self.sadEmojiImage?.isHidden = false
           // }
      //  })
    }
    // MARK: Done & Close Button Action
    @objc private func closeButtonAction(_ sender: UIButton) {
        self.view.applyCrossDissolveDismissAnimation(handler: { isExecuted in
            if isExecuted {
                self.dismiss(animated: isExecuted)
            }
        })
    }
    // MARK: No, I change my mind to Cancel account
    @objc private func cancelAccountClosureAction(_ sender: UIButton) {
        self.view.applyCrossDissolveDismissAnimation(handler: { isExecuted in
            if isExecuted {
                self.dismiss(animated: isExecuted)
            }
        })
    }
    // MARK: Yes I want to close my account
    @objc private func accountClosureAction(_ sender: UIButton) {
        self.onClickClosureAction?(true)
    }
}

// MARK: - <AccountClosureDisplayLogic> Methods
extension AccountClosureViewController: AccountClosureDisplayLogic {
    func displayRequestCallBackresponse(response: AccountClosure.AccountModel.ViewModel) {
        if response.viewModel?.status == APIStatus.statusString.success {
            self.customView?.isHidden = true
            self.callRequestView?.isHidden = false
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
        }
    }
}
