//
//  OptionalButtonCell.swift
//
//  Created by CHANDRU on 20/07/22.
//

import UIKit

class OptionalButtonCell: UICollectionViewCell {

    static let cellID = "OptionalButtonCell"

    @IBOutlet weak var optionButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         setUI()
    }
    
    private func setUI() {
        optionButton?.layer.cornerRadius = 8
        optionButton?.layer.borderWidth = 1.5
        optionButton?.layer.borderColor = UIColor.lightDisableBackgroundColor.cgColor
        optionButton?.titleLabel?.numberOfLines = 0
        optionButton?.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        optionButton?.titleLabel?.font = .setCustomFont(name: .regular, size: .x12)
        optionButton?.titleLabel?.sizeToFit()
        optionButton?.isUserInteractionEnabled = false
    }
    
    func updateSelectedButtonUI(update: Bool) {
        optionButton?.setTitleColor( update ? .white : UIColor.midGreyColor, for: .normal)
        optionButton?.backgroundColor = update ? UIColor.greenTextColor : UIColor.clear
        optionButton?.layer.borderWidth = update ? 0 : 1.5
        optionButton?.layer.borderColor = update ? UIColor.clear.cgColor : UIColor.lightDisableBackgroundColor.cgColor
    }
}
