//
//  AccountDetailsTableViewCell.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 02/04/23.
//

import UIKit

class SettingsAccountDetailsTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet weak var valueLabel: UILabel?
    @IBOutlet weak var copyButton: UIButton?
    
    var onClickCopyAction: ((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

// MARK: Initial Loads
extension SettingsAccountDetailsTableViewCell {
    
    private func initializeUI() {
        valueLabel?.font = .setCustomFont(name: .regular, size: .x14)
        valueLabel?.textColor = .primaryColor
        
        titleLabel?.font = .setCustomFont(name: .light, size: .x12)
        titleLabel?.textColor = .textLightGray
        
        copyButton?.addTarget(self, action: #selector(copyAction(sender:)), for: .touchUpInside)
        copyButton?.setBackgroundImage(UIImage(named: Image.imageString.copyBg), for: .normal)
    }
}

// MARK: Button Actions
extension SettingsAccountDetailsTableViewCell {
    // MARK: Copy Button Actions
    @objc private func copyAction( sender: UIButton) {
        onClickCopyAction?(sender.tag)
    }
}

// MARK: Set Header data
extension SettingsAccountDetailsTableViewCell {
    func updateHeaderData(data: SettingsAcccountDetailsData?) {
        titleLabel?.text = data?.titleKey ?? AppLoacalize.textString.notAvailable
        valueLabel?.text = data?.valueKey ?? AppLoacalize.textString.notAvailable
        copyButton?.tag = data?.id ?? 0
    }
}
