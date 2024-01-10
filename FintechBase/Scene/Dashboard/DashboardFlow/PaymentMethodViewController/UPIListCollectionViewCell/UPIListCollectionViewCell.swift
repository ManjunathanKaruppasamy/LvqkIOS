//
//  UPIListCollectionViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 13/03/23.
//

import UIKit

class UPIListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var upiListTitle: UILabel?
    @IBOutlet weak var upiListImageView: UIImageView?
    @IBOutlet weak var viewContent: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

}

// MARK: Initial Setup
extension UPIListCollectionViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
    }
    // MARK: Color
    private func setColor() {
        self.upiListTitle?.textColor = .black
    }
    // MARK: Font
    private func setFont() {
        self.upiListTitle?.font = UIFont.setCustomFont(name: .regular, size: .x10)
    }
    func setData(title: String, image: String) {
        self.upiListTitle?.text = title
        self.upiListImageView?.image = UIImage(named: image)
    }
}
