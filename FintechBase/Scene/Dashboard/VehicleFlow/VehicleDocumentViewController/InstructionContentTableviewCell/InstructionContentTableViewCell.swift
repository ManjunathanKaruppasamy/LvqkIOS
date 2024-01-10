//
//  InstructionContentTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//

import UIKit

class InstructionContentTableViewCell: UITableViewCell {

    @IBOutlet weak var tickImage: UIImageView?
    @IBOutlet weak var contentLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Initial Setup
extension InstructionContentTableViewCell {
    private func initialLoad() {
        self.contentLabel?.textColor = .blusihGryColor
        self.contentLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Set Up Data
    func setUPData(title: String, isTickImageEnable: Bool) {
        self.contentLabel?.text = title
        self.tickImage?.isHidden = !isTickImageEnable
    }
}
