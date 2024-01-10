//
//  ProfileUpdatesTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 20/03/23.
//

import UIKit

class ProfileUpdatesTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerCollectionView: UICollectionView?
    
    var bannerArray = ["1"]
    var onClickKYC: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProfileUpdatesTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setCollectionView()
    }
    
    // MARK: collectionview Setup
    private func setCollectionView() {
        self.bannerCollectionView?.register(UINib(nibName: Cell.identifier.bannerCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.identifier.bannerCollectionViewCell)
        self.bannerCollectionView?.delegate = self
        self.bannerCollectionView?.dataSource = self

    }
    
}

// MARK: collectionView delegate - datasource
extension ProfileUpdatesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.bannerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell: BannerCollectionViewCell = self.bannerCollectionView?.dequeueReusableCell(withReuseIdentifier: Cell.identifier.bannerCollectionViewCell, for: indexPath) as? BannerCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
    }
    
}
// MARK: CollectionView Delegate FlowLayout
extension ProfileUpdatesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bannerCollectionView?.frame.width ?? 0
        return CGSize(width: (self.bannerArray.count == 1 ? (width - 16) : (width - 30)), height: self.bannerCollectionView?.frame.height ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onClickKYC?()
    }
}
