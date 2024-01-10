//
//  BannerTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/03/23.
//

import UIKit

class BannerTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerCollectionView: UICollectionView?
    var getBannerListArray = [GetBannerResult]()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension BannerTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setCollectionView()
    }
    
    // MARK: collectionview Setup
    private func setCollectionView() {
        self.bannerCollectionView?.register(UINib(nibName: Cell.identifier.imageBannerCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.identifier.imageBannerCollectionViewCell)
        self.bannerCollectionView?.delegate = self
        self.bannerCollectionView?.dataSource = self

    }
}

// MARK: collectionView delegate - datasource
extension BannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.getBannerListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImageBannerCollectionViewCell = self.bannerCollectionView?.dequeueReusableCell(withReuseIdentifier: Cell.identifier.imageBannerCollectionViewCell, for: indexPath) as? ImageBannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureBannerImage(data: getBannerListArray[indexPath.row])
        return cell
    }
    
}
// MARK: CollectionView Delegate FlowLayout
extension BannerTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (self.getBannerListArray.count == 1 ? (self.bannerCollectionView?.frame.width ?? 0) - 16 : (self.bannerCollectionView?.frame.width ?? 0) - 50), height: 130)
    }
}
