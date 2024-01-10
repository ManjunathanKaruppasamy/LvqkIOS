//
//  CardTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/03/23.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardCollectionView: UICollectionView?
    
    var cardCellHeight = 100.0
    var addMoneyTapped: ((Int) -> Void)?
    var manageCardTapped: ((Int) -> Void)?
        var getCardResultArray: [GetCardResultArray]?
//    var getMultiCardResultArray: [MultiCardResultArray]?
    lazy var walletAmount = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension CardTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setCollectionView()
    }
    
    // MARK: collectionview Setup
    private func setCollectionView() {
        self.cardCollectionView?.register(UINib(nibName: Cell.identifier.cardCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.identifier.cardCollectionViewCell)
        self.cardCollectionView?.delegate = self
        self.cardCollectionView?.dataSource = self
    }
    
    // MARK: Add Money Button Action
    @objc private func addMoneyButtonAction(_ sender: UIButton) {
        self.addMoneyTapped?(sender.tag)
    }
    
    // MARK: Add Money Button Action
    @objc private func manageCardButtonAction(_ sender: UIButton) {
        self.manageCardTapped?(sender.tag)
    }
}

// MARK: collectionView delegate - datasource
extension CardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.getCardResultArray?.count ?? 0
        return count // (count > 0 ? count : 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CardCollectionViewCell = self.cardCollectionView?.dequeueReusableCell(withReuseIdentifier: Cell.identifier.cardCollectionViewCell, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
//        if self.getCardResultArray?.count ?? 0 > 0 {
            cell.amountLabel?.text = "\(rupeeSymbol) \(walletAmount)"
            cell.cardNoLabel?.text = self.getCardResultArray?[indexPath.item].cardNumber?.formatFasTagCardNumber() ?? ""
            cell.manageCardButton?.tag = indexPath.item
            cell.addMoneyButton?.addTarget(self, action: #selector(addMoneyButtonAction(_:)), for: .touchUpInside)
            cell.manageCardButton?.addTarget(self, action: #selector(manageCardButtonAction(_:)), for: .touchUpInside)
            //        } else {
            //            let emptyView = CommonFunctions().loadEmptyViewForCollectionViewCell(message: AppLoacalize.textString.noCardsFound, cell: cell)
            //            cell.addSubview(emptyView)
            //        }
            
//        //        if self.getCardResultArray?.count ?? 0 > 0 {
//        cell.cardNoLabel?.text = self.getMultiCardResultArray?[indexPath.item].card?.first?.cardNumber?.formatFasTagCardNumber() ?? ""
//        cell.amountLabel?.text = "\(rupeeSymbol) \((self.getMultiCardResultArray?[indexPath.item].balance?.first?.balance ?? AppLoacalize.textString.zeroAmount).getRequiredFractionFormat())"
//        cell.manageCardButton?.tag = indexPath.item
//        cell.addMoneyButton?.tag = indexPath.item
//        cell.manageCardButton?.tag = indexPath.item
//        cell.addMoneyButton?.addTarget(self, action: #selector(addMoneyButtonAction(_:)), for: .touchUpInside)
//        cell.manageCardButton?.addTarget(self, action: #selector(manageCardButtonAction(_:)), for: .touchUpInside)
//        //        } else {
//        //            let emptyView = CommonFunctions().loadEmptyViewForCollectionViewCell(message: AppLoacalize.textString.noCardsFound, cell: cell)
//        //            cell.addSubview(emptyView)
//        //        }
        return cell
    }
    
}
// MARK: CollectionView Delegate FlowLayout
extension CardTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.cardCollectionView?.frame.width ?? 0
        if self.getCardResultArray?.count ?? 0 > 0 {
            return CGSize(width: (self.getCardResultArray?.count == 1 ? (width - 10) : (width - 50)), height: self.cardCellHeight - 10)
        } else {
            return CGSize(width: width, height: self.cardCellHeight)
        }
    }
}
