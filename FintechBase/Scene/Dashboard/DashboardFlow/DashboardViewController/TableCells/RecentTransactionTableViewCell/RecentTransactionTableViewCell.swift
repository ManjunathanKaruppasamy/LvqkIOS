//
//  RecentTransactionTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/03/23.
//

import UIKit

class RecentTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionTableView: UITableView?
    @IBOutlet weak var viewAllButton: UIButton?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var noTransactionAvailableLabel: UILabel?
    
    var tapCell: ((String) -> Void)?
    var transactionHistoryData = [TransactionHistoryArrayItem]()
    var onClickViewAll:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension RecentTransactionTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setButton()
        self.setTableView()
        self.titleLabel?.textColor = .darkGreyDescriptionColor
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        self.noTransactionAvailableLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        self.noTransactionAvailableLabel?.textColor = .darkGreyDescriptionColor
        self.noTransactionAvailableLabel?.isHidden = true
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.transactionTableView?.register(UINib(nibName: Cell.identifier.transactionTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.transactionTableViewCell)
        self.transactionTableView?.delegate = self
        self.transactionTableView?.dataSource = self
        self.transactionTableView?.separatorStyle = .none
    }
    
    // MARK: set Button
    private func setButton() {
        self.viewAllButton?.setup(title: AppLoacalize.textString.viewAll, type: .skip, isEnabled: true)
        self.viewAllButton?.addTarget(self, action: #selector(setViewAllAction(_:)), for: .touchUpInside)
        
    }
    // MARK: Set View All Button Action
    @objc private func setViewAllAction(_ sender: UIButton) {
        onClickViewAll?()
    }
}

// MARK: tableView delegate - datasource
extension RecentTransactionTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactionHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TransactionTableViewCell = self.transactionTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.transactionTableViewCell, for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateTransactionHistoryData(data: transactionHistoryData[indexPath.row])
        if indexPath.row == transactionHistoryData.count - 1 {
            cell.dividerLineView?.isHidden = true
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.transactionHistoryData.isEmpty {
            self.tapCell?(transactionHistoryData[indexPath.row].externalTxnId ?? "")
        }
    }
    
}

// MARK: Load Content for data
extension RecentTransactionTableViewCell {
    
    func updateTransactionHistoryData(data: [TransactionHistoryArrayItem]) {
        
        self.transactionHistoryData = data
        
        if self.transactionHistoryData.isEmpty {
            self.tableHasData(isDataAvailable: false)
        } else {
            self.tableHasData(isDataAvailable: true)
            self.transactionTableView?.reloadInMainThread()
        }
    }
    
    private func tableHasData(isDataAvailable: Bool) {
        self.transactionTableView?.isHidden = !isDataAvailable
        self.noTransactionAvailableLabel?.isHidden = isDataAvailable
        self.noTransactionAvailableLabel?.text = AppLoacalize.textString.noTransactionAvailable
    }
}
