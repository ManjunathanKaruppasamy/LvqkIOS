//
//  PermissionViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Contacts
import CoreLocation

protocol PermissionDisplayLogic {
    func listPermissionData(data: Permission.FetchList.ViewModel)
    func displayPermissionUpdates(isAllowed: Bool, errorMsg: PermissionErrorAlert)
    func getCheckedPermissionData(data: GrantedPermission)
    func getLocationPermissionStatus(status: CLAuthorizationStatus)
}

class PermissionViewController: UIViewController {
  var interactor: PermissionBusinessLogic?
  var router: (NSObjectProtocol & PermissionRoutingLogic & PermissionDataPassing)?
  
    @IBOutlet weak var permissionTableView: UITableView?
    @IBOutlet weak var skipButton: UIButton?
    @IBOutlet weak var allowBtn: UIButton?
    @IBOutlet weak var cornerView: UIView?
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var backBtn: UIButton?
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint?
    
    var grantedPermission: GrantedPermission?
    var permissionArr = [PermissionList]()
    var allAccessGranted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitalLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allAccessGranted = false
        allowBtn?.isEnabled = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeight?.constant = permissionTableView?.contentSize.height ?? 0
    }
}

// MARK: - Initial Setup
extension PermissionViewController {
    private func setInitalLoads() {
        self.setFonts()
        self.setColors()
        self.setLocalize()
        self.setButton()
        self.setTableView()
        self.setActions()
        self.getPermissionArrData()
        NotificationCenter.default.addObserver(self, selector: #selector(callPermission(_: )), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: Fonts
    private func setFonts() {
        titleLbl?.font = .setCustomFont(name: .regular, size: .x24)
    }
    
    // MARK: Colors
    private func setColors() {
        titleLbl?.textColor = .primaryColor
    }
    
    // MARK: Localize
    private func setLocalize() {
        titleLbl?.text = AppLoacalize.textString.permission
    }
    
    // MARK: Set Button
    private func setButton() {
        
        self.allowBtn?.setup(title: AppLoacalize.textString.allowPermission, type: .primary)
        self.allowBtn?.addTarget(self, action: #selector(allowBtnAction(_:)), for: .touchUpInside)
        
        self.skipButton?.setup(title: AppLoacalize.textString.skipNow, type: .skip, skipButtonFont: UIFont.setCustomFont(name: .regular, size: .x16))
        self.skipButton?.addTarget(self, action: #selector(allowBtnAction(_:)), for: .touchUpInside)
    }
    
    // MARK: check granted permission when screen enter
    @objc private func callPermission(_ notification: NSNotification) {
//        if self.flowType == .fromProfile {
//            self.interactor?.checkPermissionGranted(checkLocationOnce: false)
//        }
    }
    
    // MARK: Allow Button Action
    @objc private func allowBtnAction(_ sender: UIButton) {
        self.router?.routeToMobileNumber()
//        self.requestAllPermissions()
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        permissionTableView?.register(UINib(nibName: Cell.identifier.permissionTableCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.permissionTableCell)
        permissionTableView?.delegate = self
        permissionTableView?.dataSource = self
    }
    
    // MARK: Set Actions
    private func setActions() {
        backBtn?.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
}

// MARK: - Methods
extension PermissionViewController {
    /* Back Button Action */
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* Show Settings Alert */
    private func showSettingsAlert(alertMessage: String) {
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
                UIApplication.shared.open(settings)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Routing
extension PermissionViewController {
    /* Move To MobileVC */
    private func moveToMobileVC() {
        if self.allAccessGranted {
//            self.router?.routeToSimSelection()
        }
    }
}

// MARK: - Interactor Requests
extension PermissionViewController {
    /* Get Permission Array Data */
    private func getPermissionArrData() {
        self.interactor?.getPermissionsData()
    }
    
    /* Requset AllPermissions */
    private func requestAllPermissions() {
        self.interactor?.requestPermissions()
    }
}

// MARK: - DisplayLogic
extension PermissionViewController: PermissionDisplayLogic {
    /* List Permissin data */
    func listPermissionData(data: Permission.FetchList.ViewModel) {
        self.permissionArr = data.permissionList ?? []
        permissionTableView?.reloadData()
        permissionTableView?.layoutIfNeeded()
    }
    
    /* Get Checked Permission data */
    func getCheckedPermissionData(data: GrantedPermission) {

        self.grantedPermission = data
        permissionTableView?.reloadData()
        DispatchQueue.main.async {
            self.permissionTableView?.layoutIfNeeded()
        }
    }
    /* Get Location Permission Status */
    func getLocationPermissionStatus(status: CLAuthorizationStatus) {
        if status == .notDetermined {
            self.interactor?.checkPermissionGranted(checkLocationOnce: true)
        } else {
            CommonFunctions.openAppSettings()
        }
    }
    
    /* Display Permission Updates */
    func displayPermissionUpdates(isAllowed: Bool, errorMsg: PermissionErrorAlert) {
        DispatchQueue.main.async {
            self.allAccessGranted = isAllowed
            guard self.allAccessGranted else {
//                self.router?.routeToErrorScreen()
                return
            }
            self.moveToMobileVC()
        }
    }
}

// MARK: - UITableViewDelegate
extension PermissionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension PermissionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        permissionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PermissionTableCell = self.permissionTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.permissionTableCell, for: indexPath) as? PermissionTableCell else {
            return UITableViewCell()
        }
        cell.setData(data: self.permissionArr[indexPath.row])
        cell.bottomLineView?.isHidden = (indexPath.row == permissionArr.count - 1)

        return cell
    }
}
