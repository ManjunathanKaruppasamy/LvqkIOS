//
//  TransactionDetailsViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 21/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PCIWidget
import PDFKit

protocol TransactionDetailsDisplayLogic: AnyObject {
    func displayTransactionDetailsData(viewModel: TransactionDetails.TransactionDetailsModel.ViewModel, transactionID: String, isCredit: Bool)
}

class TransactionDetailsViewController: UIViewController {
    var interactor: TransactionDetailsBusinessLogic?
    var router: (NSObjectProtocol & TransactionDetailsRoutingLogic & TransactionDetailsDataPassing)?
    
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var navigationTitle: UILabel?
    @IBOutlet private weak var transactionDetailTableView: UITableView?
    @IBOutlet private weak var downloadButton: UIButton?
    @IBOutlet private weak var disputeButton: UIButton?
    
    private var transactionDetailList = [TransactionDetailModel]()
    var transactionID: String = ""
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.getTransactionResponse()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationView?.applyGradient(isVertical: true, colorArray: [.appDarkPinkColor, .appDarkBlueColor])
    }
}

// MARK: Initial Set Up
extension TransactionDetailsViewController: UIDocumentInteractionControllerDelegate {
    private func initialLoads() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setButton()
        self.setTableView()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.navigationTitle?.text = AppLoacalize.textString.transactionDetails
    }
    
    // MARK: Font
    private func setFont() {
        self.navigationTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
    }
    
    // MARK: Color
    private func setColor() {
        self.navigationTitle?.textColor = .white
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.transactionDetailTableView?.register(UINib(nibName: Cell.identifier.m2pHeaderViewTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.m2pHeaderViewTableViewCell)
        self.transactionDetailTableView?.register(UINib(nibName: Cell.identifier.m2pDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.m2pDetailsTableViewCell)
        self.transactionDetailTableView?.delegate = self
        self.transactionDetailTableView?.dataSource = self
        self.transactionDetailTableView?.separatorStyle = .none
    }
    
    // MARK: set Button
    private func setButton() {
        self.disputeButton?.setup(title: AppLoacalize.textString.raiseAnIssue, type: .secondary, isEnabled: true)
        self.downloadButton?.setup(title: AppLoacalize.textString.downloadReciept, type: .primary, isEnabled: true)
        self.disputeButton?.addTarget(self, action: #selector(disputeButtonAction(_:)), for: .touchUpInside)
        self.downloadButton?.addTarget(self, action: #selector(downloadButtonAction(_:)), for: .touchUpInside)
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: Download Button Action
    @objc private func downloadButtonAction(_ sender: UIButton) {
        guard let imageData =  self.transactionDetailTableView?.takeScrollableViewScreenShot() else {
            return }
        self.createPDFDataFromImage(image: imageData)
    }
    
    private func createPDFDataFromImage(image: UIImage) {
        let imgView = UIImageView.init(image: image)
        FileLocationManager.shared.saveData(pdfView: imgView, isReceipt: true)
    }
    
    // MARK: Dispute Button Action
    @objc private func disputeButtonAction(_ sender: UIButton) {
        let SDKData = SDKModels(getCardResultArray: cardDetailsArray,
                                dob: DOB,
                                flowType: .dispute,
                                presentViewController: self,
                                transactionID: self.transactionID)
        InvokeCardManagementSdk().invokeSDK(data: SDKData, trackIssueHandler: { issueID in
            self.router?.routeToTrackIssueVC()
        })
        
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: TableView delegate - datasource
extension TransactionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.transactionDetailList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.m2pHeaderViewTableViewCell) as? M2PHeaderViewTableViewCell else {
            return UIView()
        }
        cell.headerLbl?.text = AppLoacalize.textString.transactionDetails
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.m2pDetailsTableViewCell) as? M2PDetailsTableViewCell else {
            return UITableViewCell.init()
        }
        cell.selectionStyle = .none
        cell.cellBottomAnchorConstraint?.constant = (indexPath.row == self.transactionDetailList.count - 1) ? 50 : 10
        cell.setDetails(model: self.transactionDetailList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         UITableView.automaticDimension
    }
}

// MARK: - DisplayLogic
extension TransactionDetailsViewController: TransactionDetailsDisplayLogic {
    func displayTransactionDetailsData(viewModel: TransactionDetails.TransactionDetailsModel.ViewModel, transactionID: String, isCredit: Bool) {
        if (viewModel.transactionModel?.result?.transaction?.transactionType ?? "").starts(with: "UPI") {
            disputeButton?.isHidden = true
        } else {
            disputeButton?.isHidden = isCredit
        }
        self.transactionID = transactionID
        self.transactionDetailList = viewModel.transactionDetailList ?? []
        self.transactionDetailTableView?.reloadData()
    }
}
