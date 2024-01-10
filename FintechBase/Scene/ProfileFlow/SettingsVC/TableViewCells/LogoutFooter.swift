//
//  LogoutFooter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 02/03/23.
//

import UIKit

class LogoutFooter: UITableViewHeaderFooterView {
    @IBOutlet private weak var bgView: UIView?
    @IBOutlet private weak var dividerView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var logoutButton: UIButton?
    var onclickLogout:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeUI()
    }
    
}
// MARK: Initial loads
extension LogoutFooter {
   
    // MARK: InitializeUI
    private func initializeUI() {
        [titleLabel].forEach {
            $0?.font = .setCustomFont(name: .regular, size: .x14)
            $0?.textColor = .primaryColor
            $0?.text = AppLoacalize.textString.logout
        }
        
        [self.dividerView].forEach {
            $0?.backgroundColor = .lightDisableBackgroundColor
        }
       
        logoutButton?.addTarget(self, action: #selector(logoutBtnAction), for: .touchUpInside)
        bgView?.backgroundColor = .white
        bgView?.setCornerRadius(radius: 10)
    }
}

// MARK: Button actions
extension LogoutFooter {
    // MARK: Logout button actions
    @objc private func logoutBtnAction() {
        self.onclickLogout?()
    }
}
