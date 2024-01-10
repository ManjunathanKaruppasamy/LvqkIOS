//
//  SettingsSections.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 02/03/23.
//

import UIKit
import LocalAuthentication

class SettingsSections: UITableViewCell {
    
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var itemListTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    private var itemsList: [ProfileItem]?
    var controller: UIViewController?
    private var state: Bool? = true
    var onClickRow: ((ProfileItem) -> Void)?
    var onClickBiometric: ((Bool, _ notEnroll: Bool, _ errorString: String) -> Void)?
    var context = LAContext()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        delegates()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: Initial loads
extension SettingsSections {
    // MARK: Initialize UI
    private func setupUI() {
        [titleLabel].forEach {
            $0?.font = .setCustomFont(name: .semiBold, size: .x14)
            $0?.textColor = .darkGreyDescriptionColor
        }
        self.itemListTableView?.setCornerRadius(radius: 10)
        
    }
    
    // MARK: Initialize Tableview
    private func delegates() {
        itemListTableView.rowHeight = 50
        itemListTableView.separatorColor = .clear
        itemListTableView.delegate = self
        itemListTableView.dataSource = self
        itemListTableView.showsVerticalScrollIndicator = false
        itemListTableView.register(UINib(nibName: Cell.identifier.profileDetailCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.profileDetailCell)
        DispatchQueue.main.async {
            self.itemListTableView.reloadData()
        }
    }
}

// MARK: Tableview Datasource & Delegates
extension SettingsSections: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       itemsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.profileDetailCell, for: indexPath) as? ProfileDetailCell
        cell?.selectionStyle = .none
        if let list = itemsList, indexPath.row < list.count {
            cell?.updateProfileListData(data: (self.itemsList?[indexPath.row]))
        }
        cell?.biometricSwitch?.addTarget(self, action: #selector(titleSwitchAction), for: UIControl.Event.valueChanged)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = itemsList?[indexPath.row] else {
            return
        }
        onClickRow?(item)
    }
}

// MARK: Button Actions
extension SettingsSections {
    // MARK: TitleSwitchAction
    @objc func titleSwitchAction(titleSwitch: UISwitch) {
        
        if titleSwitch.isOn {
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                self.onClickBiometric?(true, false, "")
            } else {
                self.onClickBiometric?(false, true, error?.localizedDescription ?? AppLoacalize.textString.biometryUnavailable)
            }
        } else {
             self.onClickBiometric?(false, false, "")
        }
        
        DispatchQueue.main.async {
            self.itemListTableView.reloadData()
        }
    }
}

// MARK: Set Table data
extension SettingsSections {
    
    // MARK: Configure table section data
    func loadSectionData(value: [ProfileItem], settitle: ProfileDetails) {
        if !settitle.name.isEmpty {
            self.state = true
            self.titleLabel.isHidden = false
            self.itemsList?.removeAll()
            self.itemsList = value
            self.titleLabel.text = settitle.name
       } else {
            self.state = false
            self.titleLabel.isHidden = true
            self.itemsList?.removeAll()
            self.itemsList = value
        }
        tableHeight.constant = CGFloat(value.count * 50)
        DispatchQueue.main.async {
            self.itemListTableView.reloadData()
        }
    }
}
