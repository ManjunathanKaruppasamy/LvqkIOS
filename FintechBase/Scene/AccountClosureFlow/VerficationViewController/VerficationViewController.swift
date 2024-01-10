//
//  VerficationViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Lottie

protocol VerficationDisplayLogic: AnyObject {
    func displayAccountClosure(isSuccess: Bool, getAccountClosureResponseModel: GetAccountClosureResponseModel?)
}

class VerficationViewController: UIViewController {
  var interactor: VerficationBusinessLogic?
  var router: (NSObjectProtocol & VerficationRoutingLogic & VerficationDataPassing)?
  
    @IBOutlet private weak var progressView: LottieAnimationView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var notesView: UIView?
    @IBOutlet private weak var notesTitleLabel: UILabel?
    @IBOutlet private weak var notesDescriptionLabel: UILabel?
    
    var isApiSuccess: ((Bool, String) -> Void)?
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
      initialLoads()
  }
}

// MARK: Initial Set Up
extension VerficationViewController {
    // MARK: Initial Load
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setColor()
        self.setFont()
        self.setLoacalise()
        self.setAnimaionView()
        self.notesView?.setCornerRadius()
        self.interactor?.fetchApi()
    }
    
    // MARK: Color
    private func setColor() {
        self.view.backgroundColor = .white
        self.titleLabel?.textColor = .primaryColor
        self.descriptionLabel?.textColor = .textBlackColor
        self.notesTitleLabel?.textColor = .orangeColor
        self.notesDescriptionLabel?.textColor = .blusihGryColor
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x24)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.notesTitleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.notesDescriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.verificationTitle
        self.notesTitleLabel?.text = AppLoacalize.textString.important
        self.notesDescriptionLabel?.text = AppLoacalize.textString.verificationNote
        
        let discriptionLabelString = NSMutableAttributedString(string: AppLoacalize.textString.verificationDescription)
        discriptionLabelString.apply(color: UIColor.textBlackColor, subString: "Please Wait...", textFont: .setCustomFont(name: .medium, size: .x14))
        self.descriptionLabel?.attributedText = discriptionLabelString
    }
   
    // MARK: Set Lottie AnimaionView
    private func setAnimaionView() {
        progressView?.contentMode = .scaleAspectFill
        progressView?.loopMode = .playOnce
        progressView?.play()
    }
}

// MARK: Display Logic
extension VerficationViewController: VerficationDisplayLogic {
    func displayAccountClosure(isSuccess: Bool, getAccountClosureResponseModel: GetAccountClosureResponseModel?) {
        progressView?.stop()
        self.dismiss(animated: true) {
            self.isApiSuccess?(getAccountClosureResponseModel?.status == APIStatus.statusString.success ? true : false, getAccountClosureResponseModel?.error ?? "")
        }
    }
}
