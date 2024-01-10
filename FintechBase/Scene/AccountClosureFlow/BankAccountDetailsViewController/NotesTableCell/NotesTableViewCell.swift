//
//  NotesTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet private weak var viewContent: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    
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
extension NotesTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.titleLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.titleLabel?.textColor = .orangeColor
        self.descriptionLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.descriptionLabel?.textColor = .blusihGryColor
        self.viewContent?.layer.cornerRadius = 10
    }
    
    // MARK: SetUp View
    func setUpView(title: String, description: String) {
        self.titleLabel?.text = title
        self.descriptionLabel?.text = description
    }
}
