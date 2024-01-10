//
//  UPIListTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 24/10/23.
//

import UIKit

class UPIListTableViewCell: UITableViewCell {

    @IBOutlet private weak var viewContent: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var upiListView: UIView?
    @IBOutlet private weak var secondaryView: UIView?
    @IBOutlet private weak var upiIDView: UIView?
    @IBOutlet private weak var upiIDLabel: UILabel?
    @IBOutlet private weak var rightArrow: UIImageView?
    @IBOutlet private weak var powerByView: UIView?
    @IBOutlet private weak var powerByImage: UIImageView?
    @IBOutlet private weak var upiListCollectionView: UICollectionView?
    @IBOutlet private weak var upiIDButton: UIButton?
    @IBOutlet weak var upiListCollectionViewHeight: NSLayoutConstraint?
    
    private var upiListData = [UPIListData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.upiListView?.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        self.secondaryView?.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: Initial Setup
extension UPIListTableViewCell {
    // MARK: InitialLoads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        self.setLoacalise()
        self.setCollectionView()
        self.upiIDButton?.addTarget(self, action: #selector(upiIDButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: set Color
    private func setColor() {
        self.titleLabel?.textColor = .darkGreyDescriptionColor
        self.upiIDLabel?.textColor = .hyperLinK
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
        self.upiIDLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.moneyTransferViaUPI
    }
    
    // MARK: collectionview Setup
    private func setCollectionView() {
        self.upiListCollectionView?.register(UINib(nibName: Cell.identifier.upiListCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.identifier.upiListCollectionViewCell)
        self.upiListCollectionView?.delegate = self
        self.upiListCollectionView?.dataSource = self
    }
    // MARK: upi ID Button Action
    @objc private func upiIDButtonAction(_ sender: UIButton) {
        
    }
    
    func setData(upiListData: [UPIListData]?, upiID: String?) {
        self.upiListData = upiListData ?? []
        if let upiID = upiID, !upiID.isEmpty {
            self.upiIDView?.isHidden = false
            self.upiIDButton?.isUserInteractionEnabled = true
            let upiIDLabelText = NSMutableAttributedString(string: "\(AppLoacalize.textString.myUPIID) \(upiID)")
            upiIDLabelText.apply(color: UIColor.darkGreyDescriptionColor, subString: AppLoacalize.textString.myUPIID, textFont: UIFont.setCustomFont(name: .regular, size: .x12))
            self.upiIDLabel?.attributedText = upiIDLabelText
        } else {
            self.upiIDView?.isHidden = true
            self.upiIDButton?.isUserInteractionEnabled = false
        }
        self.upiListCollectionViewHeight?.constant = 160
        self.upiListCollectionView?.reloadData()
    }
}

// MARK: collectionView delegate - datasource
extension UPIListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         self.upiListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: UPIListCollectionViewCell = self.upiListCollectionView?.dequeueReusableCell(withReuseIdentifier: Cell.identifier.upiListCollectionViewCell, for: indexPath) as? UPIListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setData(title: self.upiListData[indexPath.item].title, image: self.upiListData[indexPath.item].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
// MARK: CollectionView Delegate FlowLayout
extension UPIListTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (self.upiListCollectionView?.frame.width ?? 0)/4, height: 80)
    }
}
