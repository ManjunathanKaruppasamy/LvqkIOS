//
//  AddAddressViewController.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddAddressDisplayLogic: AnyObject {
    func displaySomething(viewModel: AddAddress.Something.ViewModel)
}

class AddAddressViewController: UIViewController {
    var interactor: AddAddressBusinessLogic?
    var router: (NSObjectProtocol & AddAddressRoutingLogic & AddAddressDataPassing)?
    
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var navigationTitle: UILabel?
    @IBOutlet private weak var addAddressTableView: UITableView?
    @IBOutlet private weak var sendFastTagButton: UIButton?
    @IBOutlet private weak var addressInfoLabel: UILabel?
    
    let bankStaticTitleLists = [AppLoacalize.textString.enterPinCode, AppLoacalize.textString.state, AppLoacalize.textString.city, AppLoacalize.textString.addressLine01, AppLoacalize.textString.addressLine02]
    let placeHolderTitleLists = [AppLoacalize.textString.enter, AppLoacalize.textString.state, AppLoacalize.textString.city, AppLoacalize.textString.addressLine01, AppLoacalize.textString.addressLine02]
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        initialLoad()
    }

    // MARK: Do something
    // @IBOutlet weak var nameTextField: UITextField!
}

// MARK: - Initial Setup
extension AddAddressViewController {
    private func initialLoad() {
        self.setLoacalise()
        self.setFont()
        self.setColor()
        self.setTableView()
        self.setButton()
    }
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.navigationTitle?.text = AppLoacalize.textString.fasttagDetails
        self.addressInfoLabel?.text = AppLoacalize.textString.addAddressInfo
    }
    
    // MARK: Font
    private func setFont() {
        self.navigationTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.addressInfoLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
    }
    
    // MARK: Set Button
    private func setButton() {
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        self.sendFastTagButton?.addTarget(self, action: #selector(sendAddressTapped(_:)), for: .touchUpInside)
        self.sendFastTagButton?.setup(title: AppLoacalize.textString.sendFastTagHere, type: .primary, isEnabled: true)
    }
    
    // MARK: Color
    private func setColor() {
        self.navigationTitle?.textColor = .white
        self.addressInfoLabel?.textColor = .primaryButtonColor
    }
    // MARK: Tableview Setup
    private func setTableView() {
        self.addAddressTableView?.register(UINib(nibName: Cell.identifier.addAddressCells, bundle: nil), forCellReuseIdentifier: Cell.identifier.addAddressCells)
        self.addAddressTableView?.separatorStyle = .none
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: send fastag  Button Action
    @objc private func sendAddressTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Interactor requests
extension AddAddressViewController {
    func doSomething() {
        let request = AddAddress.Something.Request()
        interactor?.doSomething(request: request)
    }
}

// MARK: - <AddAddressDisplayLogic> Methods
extension AddAddressViewController: AddAddressDisplayLogic {
    func displaySomething(viewModel: AddAddress.Something.ViewModel) {
        // nameTextField.text = viewModel.name
    }
}


// MARK: TableView delegate - datasource
extension AddAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankStaticTitleLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.addAddressCells) as? AddAddressCells else {
                return UITableViewCell.init()
            }
        tableViewCell.setUPIIDTextfieldView(title: bankStaticTitleLists[indexPath.row], placeholder: placeHolderTitleLists[indexPath.row], index: indexPath.row)
            return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         UITableView.automaticDimension
    }
}
