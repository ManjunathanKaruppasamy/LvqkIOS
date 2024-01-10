//
//  ReplaceFasTagViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ReplaceFasTagDisplayLogic: AnyObject {
    func displayTagList(viewModel: GetFastTag.Tag.ViewModel)
    func displayReplaceFastTag(viewModel: ReplaceFastTag.ReplaceTag.ViewModel)
    func displayVehicleNumber(number: String)
}

class ReplaceFasTagViewController: UIViewController {
    var interactor: ReplaceFasTagBusinessLogic?
    var router: (NSObjectProtocol & ReplaceFasTagRoutingLogic & ReplaceFasTagDataPassing)?
    
    @IBOutlet weak var navView: UIView?
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var navTitle: UILabel?
    
    @IBOutlet weak var vehicleNumberLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    @IBOutlet weak var reasonView: UIView?
    @IBOutlet weak var reasonTitleLabel: UILabel?
    @IBOutlet weak var tagView: TagListView?
    
    @IBOutlet weak var applyButton: UIButton?
    
    @IBOutlet weak var tagContentHeight: NSLayoutConstraint?
    private var selectedTagName: String?
    var successFailurePopUpView = SuccessFailurePopUpView()
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.navView?.applyGradient(isVertical: true, colorArray: [.appDarkPinkColor, .appDarkBlueColor])
    }
    
}

// MARK: Initial Set Up
extension ReplaceFasTagViewController {
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setAction()
        self.setColor()
        self.setFont()
        self.setStaticText()
        self.loadData()
        self.reasonView?.layer.cornerRadius = 16
        self.reasonView?.addLightShadow()
        self.interactor?.getVehicleNumber()
    }
    
    // MARK: Color
    private func setColor() {
        self.navTitle?.textColor = .white
        self.vehicleNumberLabel?.textColor = .primaryColor
        self.reasonTitleLabel?.textColor = .darkGreyDescriptionColor
        self.descriptionLabel?.textColor = .darkGreyDescriptionColor
        
    }
    
    // MARK: Font
    private func setFont() {
        self.navTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.vehicleNumberLabel?.font = UIFont.setCustomFont(name: .regular, size: .x18)
        self.reasonTitleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.navTitle?.text = AppLoacalize.textString.replaceFasTag
        self.reasonTitleLabel?.text = AppLoacalize.textString.reasonForReplacingtheFasTag
        self.descriptionLabel?.text = AppLoacalize.textString.replaceFasTagDescription
        
        let font = UIFont.setCustomFont(name: .semiBold, size: .x14)
        let descriptionLabelString = NSMutableAttributedString(string: AppLoacalize.textString.replaceFasTagDescription)
        descriptionLabelString.apply(color: UIColor.darkGreyDescriptionColor, subString: "your existing FasTag will no longer be functional.", textFont: font)
        self.descriptionLabel?.attributedText = descriptionLabelString
        
    }
    
    // MARK: set Action
    private func setAction() {
        self.applyButton?.setup(title: AppLoacalize.textString.apply, type: .primary, isEnabled: false)
        self.applyButton?.addTarget(self, action: #selector(applyButtonAction(_:)), for: .touchUpInside)
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        
    }
    // MARK: Apply Button Action
    @objc private func applyButtonAction(_ sender: UIButton) {
        self.interactor?.appleReplaceCard(reason: self.selectedTagName ?? "Others")
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*Load Data*/
    func loadData() {
        self.interactor?.getReplaceTags()
    }
    
    /* Setup tagView*/
    func setupTagView() {
        tagView?.borderColor = .lightDisableBackgroundColor
        tagView?.tagBackgroundColor = .white
        tagView?.textColor = .black
        tagView?.textFont = .setCustomFont(name: .regular, size: .x12)
        tagView?.selectedBorderColor = .white
        tagView?.tagSelectedBackgroundColor = .greenTextColor
        tagView?.selectedTextColor = .white
        tagView?.paddingX = 10
        tagView?.paddingY = 10
        tagView?.marginX = 10
        tagView?.marginY = 10
        tagView?.cornerRadius = 5
        tagView?.borderWidth = 1
        // tagView.tagHighlightedBackgroundColor = .setColour(colour: Colour.primary.rawValue)
    }
    
    // MARK: Present SuccessFailure PopUp View
    func presentSuccessFailurePopUpView() {
        self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.weWillCallBack, description: AppLoacalize.textString.replaceFasTagSuccessPopUp, image: Image.imageString.successTick, isCloseButton: true))
        self.successFailurePopUpView.onClickClose = { isClose in
            self.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(successFailurePopUpView)
        
    }
    
}

// MARK: TagListViewDelegate
extension ReplaceFasTagViewController: TagListViewDelegate {
    func viewHeight(_ height: CGFloat) {
        self.tagContentHeight?.constant = height
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
    }
}

// MARK: DisplayLogic
extension ReplaceFasTagViewController: ReplaceFasTagDisplayLogic {
    /* Display Replace FastTag */
    func displayReplaceFastTag(viewModel: ReplaceFastTag.ReplaceTag.ViewModel) {
        if viewModel.replaceTagResultModel?.status == "success" {
            self.presentSuccessFailurePopUpView()
        } else {
            // 
        }
    }
    
    /* Display Taglist */
    func displayTagList(viewModel: GetFastTag.Tag.ViewModel) {
        if let list = viewModel.replaceTagResultModel, list.count > 0 {
            self.setupTagView()
            self.tagView?.delegate = self
            list.forEach { (tagName) in
                if let name = tagName.reason {
                    self.tagView?.addTag(name).onTap = { tagView in
                        self.tagView?.tagViews.enumerated().forEach { (index, tagView) in
                            if tagView.currentTitle == name && !tagView.isSelected {
                                tagView.layer.borderColor =  UIColor.clear.cgColor
                                tagView.backgroundColor = .greenTextColor
                                tagView.setTitleColor(.white, for: .normal)
                                self.applyButton?.setPrimaryButtonState(isEnabled: true)
                                self.selectedTagName = name
                            } else {
                                tagView.isSelected = false
                                tagView.layer.borderColor = UIColor.lightDisableBackgroundColor.cgColor
                                tagView.backgroundColor = .white
                                tagView.setTitleColor(.black, for: UIControl.State.normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /* Display VehicleNumber */
    func displayVehicleNumber(number: String) {
        self.vehicleNumberLabel?.text = number
    }
}
