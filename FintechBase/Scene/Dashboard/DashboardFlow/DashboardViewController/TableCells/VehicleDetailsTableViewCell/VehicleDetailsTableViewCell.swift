//
//  VehicleDetailsTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/03/23.
//

import UIKit

class VehicleDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleDetailColectionView: UICollectionView?
    @IBOutlet weak var viewAllButton: UIButton?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var noVehicleLabel: UILabel?
    
    var vehicleListResultArray = [VehicleListResultArray]()
    var getItNowTapped: (() -> Void)?
    var onClickViewAll:(() -> Void)?
    var onClickVehicleDetails: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension VehicleDetailsTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setButton()
        self.setCollectionView()
        self.titleLabel?.textColor = .darkGreyDescriptionColor
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        self.noVehicleLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        self.noVehicleLabel?.textColor = .darkGreyDescriptionColor
        self.noVehicleLabel?.text = AppLoacalize.textString.noVehiclesFound
    }
    
    // MARK: collectionview Setup
    private func setCollectionView() { 
        self.vehicleDetailColectionView?.register(UINib(nibName: Cell.identifier.vehicleDetailsCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.identifier.vehicleDetailsCollectionViewCell)
//        self.vehicleDetailColectionView?.register(UINib(nibName: Cell.identifier.noVehicleCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.identifier.noVehicleCollectionViewCell)
        self.vehicleDetailColectionView?.delegate = self
        self.vehicleDetailColectionView?.dataSource = self
    }
    
    // MARK: set Button
    private func setButton() {
        self.viewAllButton?.setup(title: AppLoacalize.textString.viewAll, type: .skip, isEnabled: true)
        self.viewAllButton?.addTarget(self, action: #selector(setViewAllAction(_:)), for: .touchUpInside)
        
    }
    // MARK: Set View All Button Action
    @objc private func setViewAllAction(_ sender: UIButton) {
        self.onClickViewAll?()
    }
    
    @objc private func tapGetNowDescriptionLabel(gesture: UITapGestureRecognizer) {
        let cell = self.vehicleDetailColectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as? NoVehicleCollectionViewCell
        guard let textLabel = cell?.descriptionLabel else {
//            print("---none tapped")
            return
        }
        
        if gesture.didTapAttributedString("Get it now", in: textLabel) {
            self.getItNowTapped?()
        }
    }
}

// MARK: collectionView delegate - datasource
extension VehicleDetailsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.vehicleListResultArray.count
//         self.vehicleListResultArray.count > 0 ? self.vehicleListResultArray.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if self.vehicleListResultArray.count == 0 {
//            guard let cell: NoVehicleCollectionViewCell = self.vehicleDetailColectionView?.dequeueReusableCell(withReuseIdentifier: Cell.identifier.noVehicleCollectionViewCell, for: indexPath) as? NoVehicleCollectionViewCell else {
//                return UICollectionViewCell()
//            }
//            self.viewAllButton?.isHidden = true
//            let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapGetNowDescriptionLabel(gesture:)))
//            cell.descriptionLabel?.addGestureRecognizer(tapAction)
//            return cell
//        } else {
        
        guard let cell: VehicleDetailsCollectionViewCell = self.vehicleDetailColectionView?.dequeueReusableCell(withReuseIdentifier: Cell.identifier.vehicleDetailsCollectionViewCell, for: indexPath) as? VehicleDetailsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setValue(vehicleListResultArray: self.vehicleListResultArray[indexPath.item])
        self.viewAllButton?.isHidden = self.vehicleListResultArray.count > 0 ? false : true
        return cell
        
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.onClickVehicleDetails?(indexPath.item)
        self.vehicleListResultArray.count > 0 ? self.onClickVehicleDetails?(indexPath.item) : print("nil")
    }
    
}
// MARK: CollectionView Delegate FlowLayout
extension VehicleDetailsTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.vehicleListResultArray.count > 0 ? (self.vehicleDetailColectionView?.frame.width ?? 0)/2 : self.vehicleDetailColectionView?.frame.width ?? 0)  - 15
        return CGSize(width: width, height: self.vehicleDetailColectionView?.frame.height ?? 0)
//        let width = (self.vehicleListResultArray.count > 0 ? (self.vehicleDetailColectionView?.frame.width ?? 0)/2 : self.vehicleDetailColectionView?.frame.width ?? 0)  - 15
//        return CGSize(width: width, height: self.vehicleDetailColectionView?.frame.height ?? 0)
    }
}
