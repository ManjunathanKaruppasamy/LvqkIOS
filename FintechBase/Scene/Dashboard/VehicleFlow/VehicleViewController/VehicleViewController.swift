//
//  VehicleViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VehicleDisplayLogic: AnyObject {
    func displayVehicleDetails()
    func displayVehicleListResponse(viewModel: Vehicle.VehicleModel.ViewModel)
    func displayChangeTagStatusResponse(viewModel: Vehicle.VehicleModel.ViewModel)
}

class VehicleViewController: UIViewController {
    var interactor: VehicleBusinessLogic?
    var router: (NSObjectProtocol & VehicleRoutingLogic & VehicleDataPassing)?
    
    @IBOutlet private weak var slideView: UIView?
    @IBOutlet private weak var bgImage: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var addLabel: UILabel?
    @IBOutlet private weak var vehicleTableview: UITableView?
    @IBOutlet private weak var searchCustomView: UIView?
    @IBOutlet private weak var searchTextfield: UITextField?
    @IBOutlet private weak var addVehicleButton: UIButton?
    @IBOutlet private weak var customAddVehicleView: UIView?
    @IBOutlet private weak var errorSearchView: UIView?
    @IBOutlet private weak var searchImage: UIImageView?
    @IBOutlet private weak var errorTitleLabel: UILabel?
    @IBOutlet private weak var errorDescriptionLabel: UILabel?
    
    var cardHeight = 100.0
    private var vehicleListResultArray = [VehicleListResultArray]()
    private var filteredvehicleListArray = [VehicleListResultArray]()
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.fetchVehicleList()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.cardHeight = Double(slideView?.frame.height ?? 0)
        self.vehicleTableview?.reloadData()
    }
}

// MARK: Initial Set Up
extension VehicleViewController {
    func initialLoads() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setTableView()
        self.setSearchView()
        self.setButton()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.myVehicles
        self.addLabel?.text = AppLoacalize.textString.add
        self.errorTitleLabel?.text = AppLoacalize.textString.errorSearchTitle
        self.errorDescriptionLabel?.text = AppLoacalize.textString.errorDescriptionLabel
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .bold, size: .x24)
        self.addLabel?.font = .setCustomFont(name: .regular, size: .x14)
        self.errorTitleLabel?.font = .setCustomFont(name: .regular, size: .x24)
        self.errorDescriptionLabel?.font = .setCustomFont(name: .regular, size: .x14)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .white
        self.addLabel?.textColor = .primaryButtonColor
        self.errorTitleLabel?.textColor = .primaryColor
        self.errorDescriptionLabel?.textColor = .primaryColor
    }
    
    // MARK: Set Button
    private func setButton() {
        self.addVehicleButton?.addTarget(self, action: #selector(addButtonAction(_:)), for: .touchUpInside)
    }
    // MARK: Tableview Setup
    private func setTableView() {
        self.vehicleTableview?.register(UINib(nibName: Cell.identifier.vehicleListTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.vehicleListTableViewCell)
        self.vehicleTableview?.register(UINib(nibName: Cell.identifier.vehicleMessageTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.vehicleMessageTableViewCell)
        self.vehicleTableview?.delegate = self
        self.vehicleTableview?.dataSource = self
        self.vehicleTableview?.separatorStyle = .none
    }
    // MARK: set Search View
    private func setSearchView() {
        self.searchCustomView?.layer.borderColor = UIColor.lightDisableBackgroundColor.cgColor
        self.searchCustomView?.layer.borderWidth = 1
        self.searchCustomView?.setCornerRadius()
        self.customAddVehicleView?.layer.borderColor = UIColor.lightDisableBackgroundColor.cgColor
        self.customAddVehicleView?.layer.borderWidth = 1
        self.customAddVehicleView?.setCornerRadius()
        self.searchTextfield?.delegate = self
    }

    // MARK: search filter
    private func filterText(_ text: String) {

        filteredvehicleListArray = vehicleListResultArray.filter {
             ($0.entityId?.range(of: text, options: .caseInsensitive) != nil) || ($0.serialNo?.range(of: text, options: .caseInsensitive) != nil)
        }
        if filteredvehicleListArray.count == 0 {
            self.errorSearchView?.isHidden = false
        } else {
            self.errorSearchView?.isHidden = true
        }
        self.vehicleTableview?.reloadData()
    }
}

// MARK: UIbutton Actions
extension VehicleViewController {
    @objc private func addButtonAction(_ sender: UIButton) {
//        self.router?.routeToAddVehicleVC()
    }
}

// MARK: Textfields Delegates
extension VehicleViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text
        if ((text?.isEmpty) == true) {
            filteredvehicleListArray = vehicleListResultArray
            self.errorSearchView?.isHidden = true
            self.vehicleTableview?.reloadData()
        } else {
            filterText(text ?? "")
        }
    }
}

// MARK: TableView delegate - datasource
extension VehicleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredvehicleListArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == filteredvehicleListArray.count {
            guard let cell: VehicleMessageTableViewCell = self.vehicleTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.vehicleMessageTableViewCell, for: indexPath) as? VehicleMessageTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell: VehicleListTableViewCell = self.vehicleTableview?.dequeueReusableCell(withIdentifier: Cell.identifier.vehicleListTableViewCell, for: indexPath) as? VehicleListTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.statusSwitch?.tag = indexPath.row
            let vehicleStatus = CommonFunctions().getVehicleStatus(kitStatus: self.filteredvehicleListArray[indexPath.row].kitStatus ?? "")
            
            cell.setupView(vehicleStatus: vehicleStatus, vehicleListResultArray: self.filteredvehicleListArray[indexPath.row])
            cell.viewDetailsButton?.tag = indexPath.row
            cell.tapViewDetail = { index in
                self.interactor?.setDataForVehicleDetailsVC(vehicleStatus: CommonFunctions().getVehicleStatus(kitStatus: self.filteredvehicleListArray[index].kitStatus ?? ""), vehicleListResultArray: self.filteredvehicleListArray[index])
            }
            cell.onClickSwitchToggle = { tagValue in
                let switchState = (cell.statusSwitch?.isOn == true) ? "REMOVE" : "ADD"
                // API CAll For Toggle on And OFF
                self.interactor?.fetchChangeTagStatus(kitNo: self.filteredvehicleListArray[tagValue].kitNo ?? "", excCode: self.filteredvehicleListArray[tagValue].serialNo ?? "", tagOperation: switchState)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if filteredvehicleListArray.count == 0 {
            return 0
        }
       return UITableView.automaticDimension
    }
}

// MARK: - DisplayLogic
extension VehicleViewController: VehicleDisplayLogic {
    /* Display Vehicle details */
    func displayVehicleDetails() {
        self.router?.routeToVehicleDetailsVC()
    }
    
    /* Vehicle List Response */
    func displayVehicleListResponse(viewModel: Vehicle.VehicleModel.ViewModel) {
        self.vehicleListResultArray = viewModel.vehicleListResultArray ?? []
        self.filteredvehicleListArray = self.vehicleListResultArray
        self.searchTextfield?.text = ""
        if vehicleListResultArray.count == 0 {
            AddVehicleData.sharedInstace.isApplicantExist = false
            self.errorSearchView?.isHidden = false
        } else {
            AddVehicleData.sharedInstace.isApplicantExist = true
            self.errorSearchView?.isHidden = true
        }
        self.vehicleTableview?.reloadInMainThread()
    }
    /* Change Tag Status */
    func displayChangeTagStatusResponse(viewModel: Vehicle.VehicleModel.ViewModel) {
//        print(viewModel.changeTagStatusResilt?.status ?? "")
        self.interactor?.fetchVehicleList()
    }
}
