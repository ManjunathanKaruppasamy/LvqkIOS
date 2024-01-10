//
//  VerifyAccountViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Lottie

protocol VerifyAccountDisplayLogic: AnyObject {
  func displayInitialData(isFromCreateAccount: Bool)
}

class VerifyAccountViewController: UIViewController {
  var interactor: VerifyAccountBusinessLogic?
  var router: (NSObjectProtocol & VerifyAccountRoutingLogic & VerifyAccountDataPassing)?
  
    @IBOutlet weak var titleDescriptionLabel: UILabel?
    @IBOutlet weak var animationView: LottieAnimationView?
    
    var isSuccess: ((Bool) -> Void)?
    
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
      self.initialLoads()
  }
  
}

// MARK: Initial Set Up
extension VerifyAccountViewController {
    func initialLoads() {
        self.setFont()
        self.setColor()
        self.interactor?.getInitialData()
        self.setAnimaionView()
        self.navigationController?.isNavigationBarHidden = true
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
//            self.dismiss(animated: true, completion: {
//                self.isSuccess?(true)
//            })
//        }
    }
    
    // MARK: Font
    private func setFont() {
        self.titleDescriptionLabel?.font = .setCustomFont(name: .regular, size: .x16)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleDescriptionLabel?.textColor = .midGreyColor
    }
    
    // MARK: Set Lottie AnimaionView
    private func setAnimaionView() {
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopMode = .loop
        animationView?.play()
    }
  
}
extension VerifyAccountViewController: VerifyAccountDisplayLogic {
    func displayInitialData(isFromCreateAccount: Bool) {
        if isFromCreateAccount {
            let descriptionLabelString = NSMutableAttributedString(string: AppLoacalize.textString.createAccountText)
            descriptionLabelString.apply(color: UIColor.primaryColor, subString: "Your account is \ngetting created", textFont: UIFont.setCustomFont(name: .regular, size: .x24))
            
            self.titleDescriptionLabel?.attributedText = descriptionLabelString
        } else {
            let descriptionLabelString = NSMutableAttributedString(string: AppLoacalize.textString.verifyAccountText)
            descriptionLabelString.apply(color: UIColor.primaryColor, subString: "Your account has been \nverified.", textFont: UIFont.setCustomFont(name: .regular, size: .x24))
            
            self.titleDescriptionLabel?.attributedText = descriptionLabelString
        }
    }
}
