//
//  SettingsViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {
    func displayProfileData(viewModel: Settings.Profile.ViewModel)
    func moveToAnotherVC()
}
protocol UpdateDOBValueDelegate: AnyObject {
    func updatedDOBValue(isShow: Bool)
}

class SettingsViewController: UIViewController {
    @IBOutlet private weak var headerView: UIView?
    @IBOutlet private weak var topGradientView: UIView!
    @IBOutlet private weak var profileTableView: UITableView!
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var emailLabel: UILabel?
    @IBOutlet private weak var mobileNumLabel: UILabel?
    @IBOutlet private weak var updateEmailButton: UIButton?
    
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing)?
    private var contentList = [ProfileDetails]()
    private var userData: AccountData?
    private var settingsAccountDetailData = [SettingsAcccountDetailsData]()
    var delegate: UpdateDOBValueDelegate?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        initializeUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUIElements()
    }
}

// MARK: Initial setup
extension SettingsViewController {
    
    // MARK: Initialize the UI
    private func initializeUI() {
        self.view.backgroundColor = .whitebackgroundColor
        headerView?.backgroundColor = .statusBarColor
        navigationController?.navigationBar.isHidden = true
        updateEmailButton?.addTarget(self, action: #selector(updateEmailAction), for: .touchUpInside)
    }
    
    // MARK: CheckBox UI Modification
    private func enableBiometric(enable: Bool) {
        if enable {
            showSuccessToastMessage(message: AppLoacalize.textString.biometricSuccess, bgColour: .greenTextColor)
            biometricEnabled = true
        } else {
            biometricEnabled = false
            showSuccessToastMessage(message: AppLoacalize.textString.biometricFailure, bgColour: .redErrorColor)
        }
    }
    
    // MARK: Register tableview
    private func setDelegates() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.showsVerticalScrollIndicator = false
        profileTableView.separatorColor = .clear
        profileTableView.register(UINib(nibName: Cell.identifier.settingsSections, bundle: nil), forCellReuseIdentifier: Cell.identifier.settingsSections)
        profileTableView.register(UINib(nibName: Cell.identifier.logoutFooter, bundle: nil), forHeaderFooterViewReuseIdentifier: Cell.identifier.logoutFooter)
        profileTableView.register(UINib(nibName: Cell.identifier.profileHeaderCell, bundle: nil), forHeaderFooterViewReuseIdentifier: Cell.identifier.profileHeaderCell)
        profileTableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: UItableview delegates and datasource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.contentList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: Cell.identifier.profileHeaderCell) as? ProfileHeaderCell
        cell?.updateAccountDeta(data: self.settingsAccountDetailData)
        self.delegate = cell?.updateDOBDelegate
        cell?.onCopy = { data in
            if data.id == 3 {
                if data.isShowDOB {
                    self.router?.routeToMPINViewController()
                }
            } else {
                if let text = data.copiedString {
                    showSuccessToastMessage(message: "\(data.title ?? "") " + AppLoacalize.textString.copied, bgColour: .greenTextColor, position: .betweenBottomAndCenter)
                    UIPasteboard.general.string = text
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat((self.settingsAccountDetailData.count * 75) + 80)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.settingsSections, for: indexPath) as? SettingsSections
        cell?.selectionStyle = .none
        cell?.loadSectionData(value: self.contentList[indexPath.row].items, settitle: self.contentList[indexPath.row])
        cell?.onClickRow = { value in
            self.interactor?.saveToDataStore(value: value)
        }
        cell?.onClickBiometric = { (switchClick, isNotEnroll, errorDescription) in
            if isNotEnroll {
                self.showMessageAlert(title: errorDescription, message: AppLoacalize.textString.biometryUnavailableDesc, showRetry: false, cancelTitle: "OK", onRetry: nil, onCancel: nil)
            } else {
                switchClick ? self.enableBiometric(enable: true) : self.enableBiometric(enable: false)
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: Cell.identifier.logoutFooter) as? LogoutFooter
        cell?.onclickLogout = {
            self.moveToLogoutVC()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        110
    }
    
}

// MARK: Button Actions
extension SettingsViewController {
    
    // MARK: Update Email Button Action
    @objc private func updateEmailAction() {
        moveToUpdateEmailVC()
    }
}

// MARK: Interacter Requests
extension SettingsViewController {
    
    // MARK: Get Data from interacter
    private func getUIElements() {
        interactor?.getUIAttributes()
    }
}

// MARK: Routing
extension SettingsViewController {
    // MARK: Route to desired VC
    func moveToAnotherVC() {
        router?.routeToDesiredVC()
    }
    // MARK: Route to UpdateEmailVC
    func moveToUpdateEmailVC() {
        router?.routeToUpdateEmailFlow()
    }
    
    /* Move To LogoutVC */
    func moveToLogoutVC() {
        router?.routeToLogoutVC()
    }
}

// MARK: Display logic
extension SettingsViewController: SettingsDisplayLogic {
    
    // MARK: Load table data
    func displayProfileData(viewModel: Settings.Profile.ViewModel) {
        self.contentList = viewModel.profileList
        self.userData = viewModel.userData
        self.settingsAccountDetailData = viewModel.userAccountDetailList
        profileTableView.reloadInMainThread()
        loadUserProfile()
    }
    
    // MARK: Load user data
    func loadUserProfile() {
        nameLabel?.text = "Hi, \(userData?.name.capitalized ?? AppLoacalize.textString.notAvailable)"
        emailLabel?.text = userData?.email
        mobileNumLabel?.text = "\(AppLoacalize.textString.countryCode) \(userData?.mobileNumber ?? EMPTY)"
    }
}
