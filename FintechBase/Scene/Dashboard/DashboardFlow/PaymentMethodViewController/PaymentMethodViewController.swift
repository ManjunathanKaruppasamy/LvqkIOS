//
//  PaymentMethodViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 13/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PaymentMethodDisplayLogic: AnyObject {
    func displayInitialValue(amount: String)
}

class PaymentMethodViewController: UIViewController {
  var interactor: PaymentMethodBusinessLogic?
  var router: (NSObjectProtocol & PaymentMethodRoutingLogic & PaymentMethodDataPassing)?
    
    @IBOutlet weak var navigationView: UIView?
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var navigationTitle: UILabel?
    @IBOutlet weak var mainView: UIView?
    @IBOutlet weak var staticAmountToPaidLabel: UILabel?
    @IBOutlet weak var amountValueLabel: UILabel?
    @IBOutlet weak var staticPreferredPaymentLabel: UILabel?
    @IBOutlet weak var staticNoAdditionalLabel: UILabel?
    @IBOutlet weak var upiCollectionView: UICollectionView?
    @IBOutlet weak var staticOrLabel: UILabel?
    @IBOutlet weak var staticEnterUpiLabel: UILabel?
    @IBOutlet weak var upiImageView: UIImageView?
    @IBOutlet weak var upiTextField: UITextField?
    @IBOutlet weak var proceedUpiButton: UIButton?
    @IBOutlet weak var staticOtherPaymentLabel: UILabel?
    @IBOutlet weak var otherPaymentListTableView: UITableView?
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint?
        
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
      self.initialLoads()
  }
  
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.mainView?.layer.cornerRadius = 16
        self.navigationView?.applyGradient(isVertical: true, colorArray: [.appDarkPinkColor, .appDarkBlueColor])
    }
}

// MARK: Initial Set Up
extension PaymentMethodViewController {
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setAction()
        self.setColor()
        self.setFont()
        self.setStaticText()
        self.setTableView()
        self.setCollectionView()
        self.tableViewHeight?.constant = (8 * 80)
        self.interactor?.getInitialValue()
    }
    
    // MARK: Color
    private func setColor() {
        self.navigationTitle?.textColor = .white
        self.staticAmountToPaidLabel?.textColor = .midGreyColor
        self.amountValueLabel?.textColor = .primaryColor
        self.staticPreferredPaymentLabel?.textColor = .darkGreyDescriptionColor
        self.staticNoAdditionalLabel?.textColor = .blueColor
        self.staticOrLabel?.textColor = .blusihGryColor
        self.staticEnterUpiLabel?.textColor = .black
        self.upiTextField?.textColor = .midGreyColor
        self.staticOtherPaymentLabel?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        self.navigationTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.staticAmountToPaidLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.amountValueLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.staticPreferredPaymentLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
        self.staticNoAdditionalLabel?.font = UIFont.setCustomFont(name: .medium, size: .x10)
        self.staticOrLabel?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        self.staticEnterUpiLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.upiTextField?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        self.staticOtherPaymentLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.navigationTitle?.text = AppLoacalize.textString.paymentMethod
        self.staticAmountToPaidLabel?.text = AppLoacalize.textString.amountToBePaid
        self.staticPreferredPaymentLabel?.text = AppLoacalize.textString.preferredPaymentOptions
        self.staticNoAdditionalLabel?.text = AppLoacalize.textString.noAdditionalChargesforUPItransactions
        self.staticOrLabel?.text = AppLoacalize.textString.orString
        self.staticEnterUpiLabel?.text = AppLoacalize.textString.enterUPIID
        self.staticOtherPaymentLabel?.text = AppLoacalize.textString.otherPaymentOptions
        self.upiTextField?.placeholder = AppLoacalize.textString.upiPlaceHolder
    }
    
    // MARK: Set Action
    private func setAction() {
        self.proceedUpiButton?.addTarget(self, action: #selector(proceedUpiButtonAction(_:)), for: .touchUpInside)
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        
    }
    // MARK: Proceed Upi Button Action
    @objc private func proceedUpiButtonAction(_ sender: UIButton) {
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.otherPaymentListTableView?.register(UINib(nibName: Cell.identifier.otherPaymentListTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.otherPaymentListTableViewCell)
        self.otherPaymentListTableView?.delegate = self
        self.otherPaymentListTableView?.dataSource = self
        self.otherPaymentListTableView?.separatorStyle = .none
    }
    
    // MARK: Collectionview Setup
    private func setCollectionView() {
        self.upiCollectionView?.register(UINib(nibName: Cell.identifier.upiListCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.identifier.upiListCollectionViewCell)
        self.upiCollectionView?.delegate = self
        self.upiCollectionView?.dataSource = self
    }
    
}

// MARK: TableView delegate - datasource
extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: OtherPaymentListTableViewCell = self.otherPaymentListTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.otherPaymentListTableViewCell, for: indexPath) as? OtherPaymentListTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}

// MARK: collectionView delegate - datasource
extension PaymentMethodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: UPIListCollectionViewCell = self.upiCollectionView?.dequeueReusableCell(withReuseIdentifier: Cell.identifier.upiListCollectionViewCell, for: indexPath) as? UPIListCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}
// MARK: CollectionView Delegate FlowLayout
extension PaymentMethodViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: ((self.upiCollectionView?.frame.width ?? 0) / 5), height: ((self.upiCollectionView?.frame.height ?? 0) - 30))
    }
}

extension PaymentMethodViewController: PaymentMethodDisplayLogic {
    /* Display Initial Value */
    func displayInitialValue(amount: String) {
        let amountWithFloat = (String(format: "%.2f", Float(amount) ?? 0.00))
        self.amountValueLabel?.text = "\(rupeeSymbol) " + amountWithFloat
    }
}
