//
//  RequestSubmittedViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Lottie

protocol RequestSubmittedDisplayLogic: AnyObject {
    func displayInitialUI(accountCloseScreen: AccountCloseScreen)
}

class RequestSubmittedViewController: UIViewController {
    var interactor: RequestSubmittedBusinessLogic?
    var router: (NSObjectProtocol & RequestSubmittedRoutingLogic & RequestSubmittedDataPassing)?

    @IBOutlet private var progressView: LottieAnimationView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var notesView: UIView?
    @IBOutlet private weak var notesTitleLabel: UILabel?
    @IBOutlet private weak var notesDescriptionLabel: UILabel?
    
    var lottieName = ""
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
}

// MARK: Initial Set Up
extension RequestSubmittedViewController {
    // MARK: Initial Load
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setColor()
        self.setFont()
        self.setLoacalise()
        self.notesView?.setCornerRadius()
        self.interactor?.setUpInitialUI()
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
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.notesTitleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.notesDescriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.notesTitleLabel?.text = AppLoacalize.textString.pleaseNote
        let descriptionLabelAttributedString = NSMutableAttributedString(string: AppLoacalize.textString.requestSubmittedNoteDescription)
        descriptionLabelAttributedString.applyUnderLineText(color: .hyperLinK, subString: AppLoacalize.textString.supportNum, textFont: UIFont.setCustomFont(name: .regular, size: .x12), textColor: .hyperLinK)
        self.notesDescriptionLabel?.attributedText = descriptionLabelAttributedString
        self.notesDescriptionLabel?.isUserInteractionEnabled = true
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapSupportNumber(gesture:)))
        self.notesDescriptionLabel?.addGestureRecognizer(tapAction)
    }
   
    // MARK: Set Lottie AnimaionView
    private func setAnimaionView() {
        progressView?.animation = .named(self.lottieName)
        progressView?.contentMode = .scaleAspectFill
        progressView?.loopMode = .loop
        progressView?.play()
    }
    
    @objc private func tapSupportNumber(gesture: UITapGestureRecognizer) {
        if let numberUrl = URL(string: "tel://\(AppLoacalize.textString.supportNum)") {
            if UIApplication.shared.canOpenURL(numberUrl) {
                UIApplication.shared.open(numberUrl)
            }
        }
    }
}

// MARK: - <RequestSubmittedDisplayLogic> Methods
extension RequestSubmittedViewController: RequestSubmittedDisplayLogic {
    func displayInitialUI(accountCloseScreen: AccountCloseScreen) {
        switch accountCloseScreen {
        case .submitted:
            self.lottieName = "Successfully Done"
            self.titleLabel?.text = AppLoacalize.textString.requestSubmitted
            self.descriptionLabel?.text = AppLoacalize.textString.requestSubmittedDescription
        case .inProgress:
            self.lottieName = "Sand timer"
            self.titleLabel?.text = AppLoacalize.textString.requestInprogress
            self.descriptionLabel?.text = AppLoacalize.textString.requestInprogressDescription
        case .failed:
            self.lottieName = "Sand timer"
            self.titleLabel?.text = AppLoacalize.textString.requestFailed
            self.descriptionLabel?.text = AppLoacalize.textString.requestFailedDescription
        }
        self.setAnimaionView()
    }
}
