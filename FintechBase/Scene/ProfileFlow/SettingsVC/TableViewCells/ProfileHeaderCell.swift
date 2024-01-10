//
//  ProfileHeaderCell.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 03/03/23.
//

import UIKit

class ProfileHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet private weak var bgView: UIView?
    @IBOutlet private weak var headerLabel: UILabel?
    @IBOutlet private weak var grayborder: UIView?
    @IBOutlet private weak var detailsTableView: UITableView?
    var accountDetailDataList = [SettingsAcccountDetailsData]()
    var onCopy: ((OnCopyData) -> Void)?
    var updateDOBDelegate: UpdateDOBValueDelegate?
    var showDOB = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeUI()
    }
}

// MARK: Initial loads
extension ProfileHeaderCell {
    // MARK: Initialize UI
    private func initializeUI() {
        grayborder?.layer.borderColor = UIColor.lightGreyTextColor.cgColor
        grayborder?.layer.borderWidth = 0.3
        
        headerLabel?.text = AppLoacalize.textString.accountDetails
        headerLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        headerLabel?.textColor = .darkBlack
        
        self.bgView?.setCornerRadius(radius: 10)
        
        detailsTableView?.delegate = self
        detailsTableView?.dataSource = self
        updateDOBDelegate = self
        detailsTableView?.separatorColor = .clear
        detailsTableView?.register(UINib(nibName: Cell.identifier.settingsAccountDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.settingsAccountDetailsTableViewCell)
    }
}

// MARK: Set Header data
extension ProfileHeaderCell {
    func updateAccountDeta(data: [SettingsAcccountDetailsData]) {
        self.accountDetailDataList = data
        self.detailsTableView?.reloadInMainThread()
    }
}

// MARK: UITableVieDelegate & UITableViewDataSource
extension ProfileHeaderCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.accountDetailDataList.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.settingsAccountDetailsTableViewCell) as? SettingsAccountDetailsTableViewCell
        cell?.updateHeaderData(data: accountDetailDataList[indexPath.row])
        if indexPath.row == self.accountDetailDataList.count - 1 {
            cell?.copyButton?.setBackgroundImage(UIImage(named: Image.imageString.eyeopendob), for: .normal)
        } else {
            cell?.copyButton?.setBackgroundImage(UIImage(named: Image.imageString.copyBg), for: .normal)
        }
        cell?.onClickCopyAction = { index in
            let textTitle = self.accountDetailDataList[index].titleKey
            let textValue = self.accountDetailDataList[index].valueKey
            let id = self.accountDetailDataList[index].id
            
            if indexPath.row == self.accountDetailDataList.count  - 1 {
                if !self.showDOB {
                    cell?.copyButton?.setBackgroundImage(UIImage(named: Image.imageString.eyeclosedob), for: .normal)
                    self.showDOB = true
                } else {
                    cell?.copyButton?.setBackgroundImage(UIImage(named: Image.imageString.eyeopendob), for: .normal)
                    cell?.valueLabel?.text = AppLoacalize.textString.dobMasked
                    self.showDOB = false
                }
            }
            self.onCopy?(OnCopyData(title: textTitle, copiedString: textValue, id: id, isShowDOB: self.showDOB))
        }
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

// MARK: Update DOB Value Delegate
extension ProfileHeaderCell: UpdateDOBValueDelegate {
    func updatedDOBValue(isShow: Bool) {
        let cell = self.detailsTableView?.cellForRow(at: IndexPath(row: 3, section: 0)) as? SettingsAccountDetailsTableViewCell
        cell?.valueLabel?.text = isShow ? CommonFunctions.convertDateFormate(dateString: DOB, inputFormate: .ddMMyyyy, outputFormate: .ddMMMyyyy) : AppLoacalize.textString.dobMasked
        cell?.copyButton?.setBackgroundImage(UIImage(named: isShow ? Image.imageString.eyeclosedob : Image.imageString.eyeopendob), for: .normal)
    }
}
