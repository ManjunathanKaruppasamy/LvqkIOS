//
//  WalkThroughViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol WalkThroughDisplayLogic: AnyObject {
    func displaySomething(viewModel: WalkThrough.Something.ViewModel)
}

class WalkThroughViewController: UIViewController {
    var interactor: WalkThroughBusinessLogic?
    var router: (NSObjectProtocol & WalkThroughRoutingLogic & WalkThroughDataPassing)?
    
    @IBOutlet weak var subDescriptionLabel: UILabel?
    @IBOutlet weak var walletTitleLabel: UILabel?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var bgImage: UIImageView?
    @IBOutlet weak var cardImage: UIImageView?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var signInButton: UIButton?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        viewContent?.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
}
// MARK: Initial Set Up
extension WalkThroughViewController {
    func initialLoads() {
        self.setButton()
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.navigationController?.isNavigationBarHidden = true
        let request = WalkThrough.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.qww
        self.walletTitleLabel?.text = AppLoacalize.textString.tag
        
        let subDescriptionLabelString = NSMutableAttributedString(string: AppLoacalize.textString.walkThroughSubDescription)
        subDescriptionLabelString.apply(color: UIColor.primaryColor, subString: "QuikWallet", lineHeight: 1.24)
        self.subDescriptionLabel?.attributedText = subDescriptionLabelString
        
        let descriptionLabelString = NSMutableAttributedString(string: AppLoacalize.textString.walkThroughMainDescription)
        descriptionLabelString.apply(color: UIColor.primaryColor, subString: "Rupay-linked")
        descriptionLabelString.apply(color: .primaryButtonColor, subString: "card")
        self.descriptionLabel?.attributedText = descriptionLabelString
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x32)
        self.walletTitleLabel?.font = .setCustomFont(name: .semiBold, size: .x32)
        self.descriptionLabel?.font = .setCustomFont(name: .regular, size: .x16)
        self.subDescriptionLabel?.font = .setCustomFont(name: .regular, size: .x16)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryButtonColor
        self.walletTitleLabel?.textColor = .primaryButtonColor
        self.descriptionLabel?.textColor = .primaryButtonColor
        self.subDescriptionLabel?.textColor = .primaryButtonColor
    }
    // MARK: set Button
    private func setButton() {
        self.signInButton?.setup(title: AppLoacalize.textString.getStarted, type: .primary)
        self.signInButton?.addTarget(self, action: #selector(signInButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: SginIn Button Action
    @objc private func signInButtonAction(_ sender: UIButton) {
        self.router?.routeToMobileNumber()
//        self.router?.routeToPermissionViewController()
    }
}
// MARK: Display Logic
extension WalkThroughViewController: WalkThroughDisplayLogic {
    func displaySomething(viewModel: WalkThrough.Something.ViewModel) {
    }
}
