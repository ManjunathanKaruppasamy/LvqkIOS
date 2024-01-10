//
//  AccountDetailTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//

import UIKit

class AccountDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountDescriptionLbl: UILabel?
    @IBOutlet weak var accountTitleLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

// MARK: Initial Setup
extension AccountDetailTableViewCell {
    /* Initial Loads */
    private func initialLoads() {
        self.setColor()
        self.setFont()
    }
    
    // MARK: Color
    private func setColor() {
        self.accountTitleLbl?.textColor = .midGreyColor
        self.accountDescriptionLbl?.textColor = .primaryColor
    }
    
    // MARK: Font
    private func setFont() {
        self.accountTitleLbl?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.accountDescriptionLbl?.font = UIFont.setCustomFont(name: .regular, size: .x16)
    }
}

// MARK: Configure Account Details data
extension AccountDetailTableViewCell {
    /* Fill data for AccountDetailTableViewCell */
    func setData(data: AccountDetailsData) {
        self.accountTitleLbl?.text = data.title ?? ""
        self.accountDescriptionLbl?.text = data.description ?? ""
    }
}
