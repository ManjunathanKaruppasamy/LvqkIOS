//
//  OptionalButtonCell.swift
//
//  Created by CHANDRU on 20/07/22.
//

import UIKit

class OptionalButtonCell: UICollectionViewCell {

    static let cellID = "OptionalButtonCell"

    @IBOutlet weak var optionBtn: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         setUI()
    }
    
    private func setUI() {
        optionBtn?.layer.cornerRadius = 8
        optionBtn?.layer.borderWidth = 1.5
        optionBtn?.layer.borderColor = UIColor.lightDisableBackgroundColor.cgColor
        optionBtn?.titleLabel?.numberOfLines = 0
        optionBtn?.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        optionBtn?.titleLabel?.font = .setCustomFont(name: .regular, size: .x12)
        optionBtn?.titleLabel?.sizeToFit()
        optionBtn?.isUserInteractionEnabled = false
    }
    
    func updateSelectedButtonUI(update: Bool) {
            optionBtn?.setTitleColor( update ? .white : UIColor.midGreyColor, for: .normal)
            optionBtn?.backgroundColor = update ? UIColor.greenTextColor : UIColor.clear
            optionBtn?.layer.borderWidth = update ? 0 : 1.5
            optionBtn?.layer.borderColor = update ? UIColor.clear.cgColor : UIColor.lightDisableBackgroundColor.cgColor
    }
}
