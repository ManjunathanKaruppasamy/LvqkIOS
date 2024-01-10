//
//  OptionView.swift
//  YBL
//
//  Created by CHANDRU on 11/07/22.
//

import UIKit

// MARK: OptionType
 enum OptionViewType {
    case list
    case cta
    case none
}

// MARK: ListSelection Type
 enum ListOptionSelectionType {
    case single
    case multiple
}

 enum ListScrollDirection {
    case vertical
    case horizontal
}

class OptionView: UIView {
    @IBOutlet weak var optionCollectionView: UICollectionView?
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var optionStackView: UIStackView?
    @IBOutlet weak var optionCollectionHeightConstraint: NSLayoutConstraint?
    
    private var optionButtonsArray: [UIButton] = []
    private var textIndex = 0
    private var listScrollType: ListScrollDirection?
    
    private var listSelectionType: ListOptionSelectionType?
    private var selectedOptionType: OptionViewType = .none
    var textButtonArray = [String]()
    
    var onClickCTAOption: ((_ isFirstOption: Bool) -> Void)?
    var onChoosenOption: ((_ choosenArray: [String]) -> Void)?
    
    private var selectedTag = [Int]()
    var selectedOptionArray = [String]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
        
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        let view = viewFromNib()
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let view = view {
            addSubview(view)
            setUpCollectionView()
        }
    }
    
    private func setUpCollectionView() {
        self.optionCollectionView?.register(UINib(nibName: "OptionalButtonCell", bundle: nil), forCellWithReuseIdentifier: OptionalButtonCell.cellID)
        self.optionCollectionView?.delegate = self
        self.optionCollectionView?.dataSource = self
    }
    
    private func viewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view // ?? UIView()
    }
}

// MARK: - Initial Setup
extension OptionView {
    private func setUI() {
        guard !textButtonArray.isEmpty else {
            return
        }
        let requiredBtnCount = textButtonArray.count
        
        (0..<requiredBtnCount).forEach { index in
            let button = UIButton(type: .system)
            button.tag = index
            button.layer.cornerRadius = 6
            button.setTitleColor(UIColor.primaryColor, for: .normal)
            button.backgroundColor = UIColor.clear
            button.titleLabel?.numberOfLines = 0
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
            button.titleLabel?.sizeToFit()
            
            button.addTarget(self, action: #selector(optionsBtnTapped(_:)), for: .touchUpInside)
            self.optionButtonsArray.append(button)
            self.optionStackView?.addArrangedSubview(button)
        }
        
        typeLabel?.textColor = UIColor(hex: "#2B2C3E")
        typeLabel?.font = .setCustomFont(name: .regular, size: .x16)
    }
    
    // MARK: OptionViewType
    func setOptionType(type: OptionViewType, buttonTexts: [String], headerText: String? = nil, listSelectionType: ListOptionSelectionType? = .single, listScroll scrollType: ListScrollDirection? = .horizontal) {
        
        selectedOptionType = type
        self.listSelectionType = listSelectionType
        textButtonArray = buttonTexts
        self.typeLabel?.text = headerText
        self.typeLabel?.isHidden = (headerText == nil)
        selectedTag.removeAll()
        
        switch type {
        case .list:
            self.listScrollType = scrollType
            self.optionCollectionView?.isHidden = false
            self.optionStackView?.isHidden = true
            setListOptions()
        case .cta:
            self.optionCollectionView?.isHidden = true
            self.optionStackView?.isHidden = false
            setCTA()
        case .none:
            self.optionCollectionView?.isHidden = true
            self.optionStackView?.isHidden = true
            print("Type none")
        }
    }
    
    // MARK: List Option
    private func setListOptions() {
        self.typeLabel?.font = .setCustomFont(name: .medium, size: .x12)
        self.typeLabel?.textColor = UIColor.midGreyColor
        hideCollectionView(isHide: false)
        self.optionCollectionView?.allowsMultipleSelection = (listSelectionType == .multiple)
        
        switch listScrollType {
        case .horizontal:
            if let collectionLayout = self.optionCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                collectionLayout.scrollDirection = .horizontal
            }
        case .vertical:
            self.optionCollectionView?.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
            if let collectionLayout = self.optionCollectionView?.collectionViewLayout as? LeftAlignedCollectionViewFlowLayout {
                collectionLayout.scrollDirection = .vertical
            }
        case .none:
            if let collectionLayout = self.optionCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                collectionLayout.scrollDirection = .horizontal
            }
        }
            
        self.optionCollectionView?.reloadData()
        self.optionCollectionHeightConstraint?.constant =  (self.listScrollType == .vertical) ? (self.optionCollectionView?.collectionViewLayout.collectionViewContentSize.height ?? 35) : 35
    }
    
    // MARK: CTA Option
    private func setCTA() {
        setUI()
        optionStackView?.distribution = .fillEqually
        optionStackView?.spacing = 14
        hideCollectionView(isHide: true)
        
        optionButtonsArray.forEach { optBtn in
            optBtn.setTitle(self.textButtonArray[textIndex], for: .normal)
            textIndex += 1
        }
    }
}

// MARK: - Methods
extension OptionView {

    @objc func optionsBtnTapped(_ sender: UIButton) {
        guard self.selectedOptionType == OptionViewType.cta else {
            print(self.selectedOptionType)
            return
        }
        
        print(sender.tag)
        optionButtonsArray.forEach { optBtn in
            optBtn.backgroundColor = UIColor.lightDisableBackgroundColor
            optBtn.setTitleColor(UIColor.midGreyColor, for: .normal)
        }
        sender.backgroundColor = UIColor.greenTextColor
        sender.setTitleColor(.white, for: .normal)
        self.onClickCTAOption?(sender.tag == 0)
    }
    
    private func hideCollectionView(isHide: Bool) {
        self.optionCollectionView?.isHidden = isHide
        self.optionStackView?.isHidden = !isHide
    }
    
    func clearSelectedList() {
        selectedTag.forEach { itemTag in
            if let cell = self.optionCollectionView?.cellForItem(at: IndexPath(row: itemTag, section: 0)) as? OptionalButtonCell {
                cell.updateSelectedButtonUI(update: false)
            }
        }
        self.selectedOptionArray.removeAll()
        self.selectedTag.removeAll()
    }
    
}

// MARK: - UICollectionViewDataSource

extension OptionView: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        textButtonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.optionCollectionView?.dequeueReusableCell(withReuseIdentifier: OptionalButtonCell.cellID, for: indexPath) as? OptionalButtonCell else {
            return UICollectionViewCell.init()
        }
        let title = self.textButtonArray[indexPath.item]
        cell.optionBtn?.setTitle(title, for: .normal)
        self.selectedTag.contains(indexPath.row) ? (cell.updateSelectedButtonUI(update: true)) : (cell.updateSelectedButtonUI(update: false))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension OptionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = self.optionCollectionView?.cellForItem(at: indexPath) as? OptionalButtonCell {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            selectedOptionArray.removeAll()
            if let index = selectedTag.firstIndex(of: indexPath.item) {
                self.selectedTag.remove(at: index)
                cell.updateSelectedButtonUI(update: false)
            } else {
                self.selectedTag.append(indexPath.item)
                if listSelectionType == .single && selectedTag.count > 1 {
                    self.selectedTag.removeFirst()
                }
                cell.updateSelectedButtonUI(update: true)
            }
            selectedTag.forEach { tag in
                selectedOptionArray.append(self.textButtonArray[tag])
            }
            self.onChoosenOption?(self.selectedOptionArray)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = self.optionCollectionView?.cellForItem(at: indexPath) as? OptionalButtonCell {
            selectedOptionArray.removeAll()
            if let index = selectedTag.firstIndex(of: indexPath.item) {
                self.selectedTag.remove(at: index)
            }
            cell.updateSelectedButtonUI(update: false)
            selectedTag.forEach({ self.selectedOptionArray.append(textButtonArray[$0]) })
            self.onChoosenOption?(self.selectedOptionArray)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
        self.optionCollectionHeightConstraint?.constant =  (self.listScrollType == .vertical) ? (self.optionCollectionView?.collectionViewLayout.collectionViewContentSize.height ?? 35) : 35
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OptionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (textButtonArray[indexPath.item] as NSString).size(withAttributes: [.font: UIFont.setCustomFont(name: .regular, size: .x12)]).width + 30
        return CGSize(width: 70, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}

// MARK: - LeftAlignedCollectionViewFlowLayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
