//
//  AccountDetailsViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AccountDetailsDisplayLogic: AnyObject {
    func displayCustomerRegisterResponse(viewModel: AccountDetails.FetchList.ViewModel)
    func listAccountDetailsData(data: AccountDetails.FetchList.ViewModel, flowEnum: ModuleFlowEnum, userState: UserState)
}

class AccountDetailsViewController: UIViewController {
    var interactor: AccountDetailsBusinessLogic?
    var router: (NSObjectProtocol & AccountDetailsRoutingLogic & AccountDetailsDataPassing)?
    private var flowEnum: ModuleFlowEnum = .none
    
    @IBOutlet weak var accountDetailsTableView: UITableView?
    @IBOutlet weak var tittleLbl: UILabel?
    @IBOutlet weak var setPinBttn: UIButton?
    @IBOutlet weak var subTitleLabel: UILabel?
    @IBOutlet weak var doLaterButton: UIButton?
    
    private var accountDetails = [AccountDetailsData]()
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
}

// MARK: Initial Set Up
extension AccountDetailsViewController {
    /* Initial loads */
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setAction()
        self.setColor()
        self.setFont()
        self.setTableView()
        self.setStaticText()
        self.subTitleLabel?.isHidden = true
        self.tittleLbl?.isHidden = true
        self.setPinBttn?.isHidden = true
        self.doLaterButton?.isHidden = true
        self.accountDetailsTableView?.isHidden = true
        self.interactor?.fetchAccountDetails()
    }
    
    // MARK: Color
    private func setColor() {
        self.tittleLbl?.textColor = .primaryColor
        self.subTitleLabel?.textColor = .darkGray
    }
    
    // MARK: Font
    private func setFont() {
        self.tittleLbl?.font = UIFont.setCustomFont(name: .regular, size: .x24)
        self.subTitleLabel?.font = .setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.tittleLbl?.text = AppLoacalize.textString.accountDetailsTitle
        self.subTitleLabel?.isHidden = !(flowEnum == .videoKYC)
        self.subTitleLabel?.text = AppLoacalize.textString.verifyYourDetails
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.accountDetailsTableView?.register(UINib(nibName: Cell.identifier.accountDetailTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.accountDetailTableViewCell)
        self.accountDetailsTableView?.separatorStyle = .none
        self.accountDetailsTableView?.delegate = self
        self.accountDetailsTableView?.dataSource = self
    }
    
    // MARK: Set Action
    private func setAction() {
        self.setPinBttn?.setup(title: flowEnum == .videoKYC ? AppLoacalize.textString.continueToVideoKYC : AppLoacalize.textString.setMPIN, type: .primary, isEnabled: true)
        self.setPinBttn?.addTarget(self, action: #selector(setPinBttnAction(_:)), for: .touchUpInside)
        self.doLaterButton?.setup(title: AppLoacalize.textString.doThisLater, type: .skip, skipButtonFont: UIFont.setCustomFont(name: .regular, size: .x16))
        self.doLaterButton?.addTarget(self, action: #selector(doLaterButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Do Later Button Action
    @objc private func doLaterButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Set MPin Button Action
    @objc private func setPinBttnAction(_ sender: UIButton) {
        self.flowEnum == .videoKYC ? self.router?.routeToStartKycViewController() : self.router?.routeToMPINViewController()
    }
    
}

// MARK: - UITableViewDelegate
extension AccountDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension AccountDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.accountDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AccountDetailTableViewCell = self.accountDetailsTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.accountDetailTableViewCell, for: indexPath) as? AccountDetailTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setData(data: self.accountDetails[indexPath.row])
        
        return cell
    }
}
// MARK: Pass Email Value Delegate
extension AccountDetailsViewController: PassEmailValueDelegate {
    func passEmailValue(title: String, email: String) {
        /* To show Animation */
//        self.router?.routeToVerifyAccount(isFromCreateAccount: true)
        self.interactor?.callRegisterCustomerAPi(title: title, email: email)
    }
}
// MARK: Display logic
extension AccountDetailsViewController: AccountDetailsDisplayLogic {
    func displayCustomerRegisterResponse(viewModel: AccountDetails.FetchList.ViewModel) {
        if (viewModel.registerUserResponseData?.status ?? "").uppercased() == APIStatus.statusString.success.uppercased() {
            self.dismiss(animated: true, completion: nil)
            self.router?.routeToVerifyAccount(isFromCreateAccount: true)
            ACCESSTOKEN = viewModel.registerUserResponseData?.accessToken ?? ""
            REFRESHTOKEN = viewModel.registerUserResponseData?.refreshToken ?? ""
            self.interactor?.fetchOldAccountDetails()
        } else {
            showSuccessToastMessage(message: viewModel.registerUserResponseData?.error ?? AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
//                self.dismiss(animated: true, completion: {
//                    self.navigationController?.popViewController(animated: true)
//                })
        }
    }
    /* Display List AccountDetailsData */
    func listAccountDetailsData(data: AccountDetails.FetchList.ViewModel, flowEnum: ModuleFlowEnum, userState: UserState) {
        
        switch userState {
        case .new:
            self.router?.routeToSetEmailViewController()
        case .none:
            /* To show Animation */
            self.router?.routeToVerifyAccount(isFromCreateAccount: false)
            self.interactor?.fetchOldAccountDetails()
        default:
            self.accountDetails = data.accountDetails ?? []
            self.flowEnum = flowEnum
            DispatchQueue.main.async {
                self.accountDetailsTableView?.reloadData()
                self.setAction()
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(self.flowEnum != .videoKYC ? 3 : 1)) {
                self.dismiss(animated: true, completion: {
                    self.tittleLbl?.isHidden = false
                    self.setPinBttn?.isHidden = false
                    self.doLaterButton?.isHidden = !(flowEnum == .videoKYC)
                    self.subTitleLabel?.isHidden = !(flowEnum == .videoKYC)
                    self.accountDetailsTableView?.isHidden = false
                })
            }
        }
    }
}
