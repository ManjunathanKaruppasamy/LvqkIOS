//
//  FastTagDetailsViewController.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FastTagDetailsDisplayLogic: AnyObject {
    func displayPayUResponse(paymentParam: PayUResponse)
    func displayGetFastTagFeeData(viewModel: FastTagDetails.FastTagFeeModel.ViewModel)
    func displayAddVehicleResponse(addVehicleParam: AddVehicleResponce)
}

class FastTagDetailsViewController: UIViewController {
    var interactor: FastTagDetailsBusinessLogic?
    var router: (NSObjectProtocol & FastTagDetailsRoutingLogic & FastTagDetailsDataPassing)?

    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var navigationTitle: UILabel?
    @IBOutlet private weak var fastTagDetailTableView: UITableView?
    
    private var getFastTagFeeData: FastTagFeeResult?
    var payUResponse: PayUResponse?
    var addVehicleResonse: AddVehicleResponce?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactorAPICalls()
        self.initialLoad()
        self.view.backgroundColor = .whitebackgroundColor
    }
}

// MARK: - Initial Setup
extension FastTagDetailsViewController {
    private func initialLoad() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setTableView()
        self.setButton()
        self.navigationController?.isNavigationBarHidden = true
    }
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.navigationTitle?.text = AppLoacalize.textString.fasttagDetails
    }
    
    // MARK: Font
    private func setFont() {
        self.navigationTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
    }
    
    // MARK: Set Button
    private func setButton() {
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: Color
    private func setColor() {
        self.navigationTitle?.textColor = .white
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.fastTagDetailTableView?.register(UINib(nibName: Cell.identifier.fastTagFeeBreakdownCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.fastTagFeeBreakdownCell)
        self.fastTagDetailTableView?.register(UINib(nibName: Cell.identifier.deliveryAddressCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.deliveryAddressCell)
        self.fastTagDetailTableView?.register(UINib(nibName: Cell.identifier.fastTagPaymentCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.fastTagPaymentCell)
        self.fastTagDetailTableView?.register(UINib(nibName: Cell.identifier.quikPaymentCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.quikPaymentCell)
        self.fastTagDetailTableView?.separatorStyle = .none
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Interactor requests
extension FastTagDetailsViewController {
    func interactorAPICalls() {
        interactor?.fetchFastTagDetailsFee()
    }
}

// MARK: - <FastTagDetailsDisplayLogic> Methods
extension FastTagDetailsViewController: FastTagDetailsDisplayLogic {
    func displayGetFastTagFeeData(viewModel: FastTagDetails.FastTagFeeModel.ViewModel) {
        if let fastTagList = viewModel.getfastTagFeeModel?.result {
            self.getFastTagFeeData = fastTagList
            self.fastTagDetailTableView?.reloadInMainThread()
        }
    }
    /* Display PayU Response */
    func displayPayUResponse(paymentParam: PayUResponse) {
        self.payUResponse = paymentParam
        self.router?.routeToPayUVC()
    }
    
    // MARK: Display add vehicle response
    func displayAddVehicleResponse(addVehicleParam: AddVehicleResponce) {
        self.addVehicleResonse = addVehicleParam
        showSuccessToastMessage(message: AppLoacalize.textString.vehicleSuccessMessage, messageColor: .white, bgColour: UIColor.greenColor)
        DispatchQueue.main.async {
            self.popToViewController(destination: TabbarViewController.self)
        }
    }
    func addVehicleApiIntegrate() {
        self.interactor?.getAddVehicleData()
    }
}

// MARK: TableView delegate - datasource
extension FastTagDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.fastTagFeeBreakdownCell) as? FastTagFeeBreakdownCell else {
                return UITableViewCell.init()
            }
            cell.setCellData(fastTagFeeData: getFastTagFeeData)
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.deliveryAddressCell) as? DeliveryAddressCell else {
                return UITableViewCell.init()
            }
            cell.onClickChange = { isChange in
                self.router?.routeToAddAddressVC()
            }
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.quikPaymentCell) as? QuikPaymentCell else {
                return UITableViewCell.init()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.fastTagPaymentCell) as? FastTagPaymentCell else {
                return UITableViewCell.init()
            }
            cell.onClickPayment = { viewTag in
                if viewTag == 1 { // UPI Apps
                    self.router?.routeToUPIAppVC()
                } else { // Other payment option
                    self.interactor?.getGenerateHashResponse(amount: "\(self.getFastTagFeeData?.total ?? 0.0)", extTxnId: CommonFunctions().getPGtransactionID())
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            self.addVehicleApiIntegrate()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return (walletBalance > self.getFastTagFeeData?.total ?? 0) ? UITableView.automaticDimension : 0
        }
        return UITableView.automaticDimension
    }
}
