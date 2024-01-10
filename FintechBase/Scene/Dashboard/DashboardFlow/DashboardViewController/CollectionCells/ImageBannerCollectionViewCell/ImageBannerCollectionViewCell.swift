//
//  ImageBannerCollectionViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/03/23.
//

import UIKit

class ImageBannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /* Configure BannerImage */
    func configureBannerImage(data: GetBannerResult) {
        guard let imageData = data.image, !imageData.isEmpty else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            guard let image =  imageData.base64ToImage() else {
                return
            }
            guard let compressedData = image.jpeg(.low) else {
                return
            }
            let compressImg =  UIImage(data: compressedData)
            DispatchQueue.main.async {
                self.bannerImageView?.image = compressImg
            }
        }
    }
}
