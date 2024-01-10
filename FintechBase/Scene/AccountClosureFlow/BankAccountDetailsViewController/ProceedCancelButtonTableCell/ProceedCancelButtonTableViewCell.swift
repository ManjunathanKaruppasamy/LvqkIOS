//
//  ProceedCancelButtonTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//

import UIKit

class ProceedCancelButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var skipButton: UIButton?
    @IBOutlet weak var primaryButton: UIButton?
    
    var onClikButton: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: Initial Set Up
extension ProceedCancelButtonTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.primaryButton?.tag = 1
        self.skipButton?.tag = 2
        self.primaryButton?.addTarget(self, action: #selector(setButtonAction(_:)), for: .touchUpInside)
        self.skipButton?.addTarget(self, action: #selector(setButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Set Button Action
    @objc private func setButtonAction(_ sender: UIButton) {
        self.onClikButton?(sender.tag)
    }
    // MARK: Set Button
    func setUpButton(primaryButton: ButtonData, skipButton: ButtonData) {
        self.primaryButton?.setup(title: primaryButton.title, type: .primary, isEnabled: primaryButton.isEnable)
        self.skipButton?.setup(title: skipButton.title, type: .skip, isEnabled: skipButton.isEnable)
    }
}
