//
//  NotesListTableViewCell.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//

import UIKit

class NotesListTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
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

// MARK: Initial loads
extension NotesListTableViewCell {
    
    private func initializeUI() {
        titleLabel?.textColor = .darkGray
        titleLabel?.font = .setCustomFont(name: .regular, size: .x14)
    }
}

// MARK: Fill StartKyc Notes Data
extension NotesListTableViewCell {
    
    func updateData(data: NotesListModel) {
        titleLabel?.text = data.titleMessage
    }
}
