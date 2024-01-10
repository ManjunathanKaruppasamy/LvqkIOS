//
//  AccountDetailsTableViewCell.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 02/04/23.
//

import UIKit

class SettingsAccountDetailsTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var valueLabel: UILabel?
    @IBOutlet private weak var copyButton: UIButton?
    var onClickCopyAction: ((String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: Initial Loads
extension SettingsAccountDetailsTableViewCell {
    
    private func initializeUI() {
        titleLabel?.font = .setCustomFont(name: .regular, size: .x14)
        titleLabel?.textColor = .primaryColor
        
        valueLabel?.font = .setCustomFont(name: .light, size: .x12)
        valueLabel?.textColor = .textLightGray
        
        copyButton?.addTarget(self, action: #selector(copyAction(sender:)), for: .touchUpInside)
        copyButton?.setBackgroundImage(UIImage(named: Image.imageString.copyBg), for: .normal)
    }
}

// MARK: Button Actions
extension SettingsAccountDetailsTableViewCell {
    // MARK: Copy Button Actions
    @objc private func copyAction( sender: UIButton) {
//        let tag = sender.tag
//        switch tag {
//        case 1:
//            onClickCopyAction?(accountNumberValueLabel?.text)
//        case 2:
//            onClickCopyAction?(ifscValueLabel?.text)
//        case 3:
//            onClickCopyAction?(upiIdValueLabel?.text)
//        case 4:
//            onClickCopyAction?(netcUpiValueLabel?.text)
//        default:
//            break
//        }
    }
}
