//
//  SupportListTableViewCell.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 06/03/23.
//

import UIKit

class SupportListTableViewCell: UITableViewCell {
    @IBOutlet private weak var queryLabel: UILabel?
    @IBOutlet private weak var clickableLabel: UILabel?
    @IBOutlet private weak var iconImageView: UIImageView?
    
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
extension SupportListTableViewCell {
   
    /* Initial loads */
    private func initializeUI() {
        [queryLabel, clickableLabel].forEach {
            $0?.font = .setCustomFont(name: .regular, size: .x14)
        }
        
        queryLabel?.textColor = .darkBlack
        clickableLabel?.textColor = .hyperLinK
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(tapGestureRecognizer:)))
        clickableLabel?.isUserInteractionEnabled = true
        clickableLabel?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Clickable label Action
    @objc private func labelTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let contactText = clickableLabel?.text ?? ""
        if contactText.isValidEmail() {
            if let url = URL(string: "mailto:\(contactText)") {
                UIApplication.shared.openURL(url)
            }
        } else {
            if let numberUrl = URL(string: "tel://\(contactText)") {
                if UIApplication.shared.canOpenURL(numberUrl) {
                    UIApplication.shared.open(numberUrl)
                }
            }
        }
    }
}

// MARK: Set SupportList Data
extension SupportListTableViewCell {
    
    /* Upload Support List data */
    func uplaodData(data: SupportList?) {
        guard let data  = data else {
            return
        }
        
        iconImageView?.image = UIImage(named: data.img ?? "")
        queryLabel?.text = data.title ?? ""
        clickableLabel?.text = data.clickValue ?? ""
    }
}
