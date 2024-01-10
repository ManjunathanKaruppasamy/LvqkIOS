//
//  UPIAppsBottomSheetViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/06/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UPIAppsBottomSheetDisplayLogic: AnyObject {
    func displayUPIAppsList(upiAppsList: [UPIAppsData])
    func displayGetReferenceId(viewModel: UPIAppsBottomSheet.UPIAppsBottomSheetModel.ViewModel)
    func displayTransactionDetails(viewModel: UPIAppsBottomSheet.UPIAppsBottomSheetModel.ViewModel)
}

class UPIAppsBottomSheetViewController: UIViewController {
    var interactor: UPIAppsBottomSheetBusinessLogic?
    var router: (NSObjectProtocol & UPIAppsBottomSheetRoutingLogic & UPIAppsBottomSheetDataPassing)?
    
    @IBOutlet private weak var closeButton: UIButton?
    @IBOutlet private weak var viewContent: UIView?
    @IBOutlet private weak var closeImageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var upiAppListTableView: UITableView?
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint?
    
    var upiAppListArr = [UPIAppsData]()
    var callTransactionAPI = false
    var isPaymentSuccess: ((Bool) -> Void)?
    var getReferenceIdResponse: GetReferenceIdResponse?
    var selectedIndex = 999
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.applyCrossDissolvePresentAnimation()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Initial Set Up
extension UPIAppsBottomSheetViewController {
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setButton()
        self.setColor()
        self.setFont()
        self.setStaticText()
        self.setTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.interactor?.getUPIAppsList()
    }
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
    }
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
    }
    // MARK: Static Text
    private func setStaticText() {
        self.titleLabel?.text = AppLoacalize.textString.upiApps
    }
    // MARK: Tableview Setup
    private func setTableView() {
        self.upiAppListTableView?.register(UINib(nibName: Cell.identifier.upiAppTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.upiAppTableViewCell)
        self.upiAppListTableView?.delegate = self
        self.upiAppListTableView?.dataSource = self
        self.upiAppListTableView?.separatorStyle = .none
    }
    // MARK: Set Button
    private func setButton() {
        self.closeButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
    }
    // MARK: Close Button Action
    @objc private func closeButtonAction(_ sender: UIButton) {
        self.view.applyCrossDissolveDismissAnimation(handler: { isExecuted in
            if isExecuted {
                self.dismiss(animated: isExecuted)
            }
        })
    }
    @objc func willEnterForeground() {
        if callTransactionAPI {
            self.interactor?.fetchTransactionByTxnIdApi(transactionID: self.getReferenceIdResponse?.result?.txnId,
                                                        refId: self.getReferenceIdResponse?.result?.refId)
        }
    }
}

// MARK: - UITableViewDataSource
extension UPIAppsBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.upiAppListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.upiAppListTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.upiAppTableViewCell) as? UPIAppTableViewCell else {
            return UITableViewCell.init()
        }
        cell.selectionStyle = .none
        cell.upiNameLabel?.text = self.upiAppListArr[indexPath.row].name ?? ""
        let imgae = UIImage(named: self.upiAppListArr[indexPath.row].name ?? "")
        cell.upiImageView?.image = imgae != nil ? imgae : UIImage(named: Image.imageString.upiCircle)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension UPIAppsBottomSheetViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.interactor?.getReferenceIdApi()
    }
}

// MARK: - DisplayLogic
extension UPIAppsBottomSheetViewController: UPIAppsBottomSheetDisplayLogic {
    func displayUPIAppsList(upiAppsList: [UPIAppsData]) {
        self.upiAppListArr = upiAppsList
        if self.upiAppListArr.count == 0 {
            self.view.applyCrossDissolveDismissAnimation(handler: { isExecuted in
                self.dismiss(animated: true, completion: {
                    showSuccessToastMessage(message: AppLoacalize.textString.noUPIAppsFound, messageColor: .white, bgColour: .greenTextColor, position: .betweenBottomAndCenter)
                })
            })
            
        } else {
            self.tableViewHeightConstraint?.constant = CGFloat(upiAppListArr.count * 60)
            self.upiAppListTableView?.reloadData()
        }
        
    }
    func displayGetReferenceId(viewModel: UPIAppsBottomSheet.UPIAppsBottomSheetModel.ViewModel) {
        self.getReferenceIdResponse = viewModel.getReferenceIdResponse
        self.callTransactionAPI = true
        guard let urn = ((self.getReferenceIdResponse?.result?.urn ?? "").components(separatedBy: "://")[1]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: (self.upiAppListArr[self.selectedIndex].pushURL ?? "") + urn) else {
            return
        }
        UIApplication.shared.open(url as URL)
    }
    
    func displayTransactionDetails(viewModel: UPIAppsBottomSheet.UPIAppsBottomSheetModel.ViewModel) {
        self.callTransactionAPI = false
        let status = viewModel.fetchTransactionResponse?.status?.uppercased() == "SUCCESS" && viewModel.fetchTransactionResponse?.result?.first?.status?.uppercased() == "SUCCESS"
        self.dismiss(animated: true) {
            self.isPaymentSuccess?(status)
        }
        
    }
}
