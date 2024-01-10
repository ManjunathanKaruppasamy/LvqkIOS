//
//  MPINSuccessViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Lottie
import LocalAuthentication

protocol MPINSuccessDisplayLogic: AnyObject {
    func displayBiometricStatus(isFailed: Bool, alertData: AlertData?)
    func displaySetupViewDate(setMPINView: SetMPINView)
}

class MPINSuccessViewController: UIViewController {
    var interactor: MPINSuccessBusinessLogic?
    var router: (NSObjectProtocol & MPINSuccessRoutingLogic & MPINSuccessDataPassing)?
    
    @IBOutlet weak var mainSuccessBiometricView: UIView?
    @IBOutlet weak var successAnimationView: LottieAnimationView?
    @IBOutlet weak var successDescriptionView: UILabel?
    @IBOutlet weak var enableBiometricButton: UIButton?
    @IBOutlet weak var skipBiometricButton: UIButton?
    
    @IBOutlet weak var dimmedView: UIView?
    @IBOutlet weak var unlockBiometricView: UIView?
    @IBOutlet weak var unlockBiometricImage: UIImageView?
    @IBOutlet weak var unlockBiometricTitleLbl: UILabel?
    @IBOutlet weak var useMPINButton: UIButton?
    @IBOutlet weak var unlockBiometricButton: UIButton?
    @IBOutlet weak var unlockBiometricDescription: UILabel?
    
    var setMPINView: SetMPINView = .successShowMPIN
    var useMPINTapped:(() -> Void)?
    var biometricMatched: (() -> Void)?
    var context = LAContext()
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitalLoads()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.unlockBiometricView?.roundCorners(corners: [.topLeft, .topRight], radius: 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.applyCrossDissolvePresentAnimation(duration: 1, delay: 0.4)
    }
}

// MARK: - Initial Setup
extension MPINSuccessViewController {
    /* Initial Loads */
    private func setInitalLoads() {
        self.setFonts()
        self.setColors()
        self.setLocalize()
        self.setButton()
        self.setAnimaionView()
        self.interactor?.getSetupViewDate()
    }
    
    // MARK: Fonts
    private func setFonts() {
        successDescriptionView?.font = .setCustomFont(name: .regular, size: .x24)
        unlockBiometricTitleLbl?.font = .setCustomFont(name: .semiBold, size: .x18)
        unlockBiometricDescription?.font = .setCustomFont(name: .regular, size: .x14)
    }
    
    // MARK: Colors
    private func setColors() {
        successDescriptionView?.textColor = .primaryColor
        unlockBiometricTitleLbl?.textColor = .primaryColor
        unlockBiometricDescription?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Localize
    private func setLocalize() {
        successDescriptionView?.text = AppLoacalize.textString.mpinSuccess
        unlockBiometricTitleLbl?.text = AppLoacalize.textString.unlockQuikWallet
        unlockBiometricDescription?.text = AppLoacalize.textString.touchTheFingerprintSensor
    }
    
    // MARK: Set Lottie AnimaionView
    private func setAnimaionView() {
        successAnimationView?.contentMode = .scaleAspectFill
        successAnimationView?.loopMode = .playOnce
        successAnimationView?.play()
    }
    
    // MARK: Set Button
    private func setButton() {
        self.useMPINButton?.setup(title: AppLoacalize.textString.useMPIN, type: .skip)
        self.useMPINButton?.addTarget(self, action: #selector(useButtonAction(_:)), for: .touchUpInside)
        
        self.enableBiometricButton?.setup(title: AppLoacalize.textString.enableBiometric, type: .primary)
        self.enableBiometricButton?.addTarget(self, action: #selector(enableBiometricButtonAction(_:)), for: .touchUpInside)
        
        self.skipBiometricButton?.setup(title: AppLoacalize.textString.skipForNow, type: .skip, skipButtonFont: UIFont.setCustomFont(name: .regular, size: .x14))
        self.skipBiometricButton?.addTarget(self, action: #selector(skipBiometricButtonAction(_:)), for: .touchUpInside)
        
        self.unlockBiometricButton?.addTarget(self, action: #selector(enableBiometricButtonAction(_:)), for: .touchUpInside)
        
    }

    // MARK: Enable Biometric Button Action
    @objc private func enableBiometricButtonAction(_ sender: UIButton) {
        self.interactor?.callBiometric()
    }
    
    // MARK: Skip Biometric Button Action
    @objc private func skipBiometricButtonAction(_ sender: UIButton) {
        biometricEnabled = false
        self.router?.routeToTabbarController()
    }
    
    // MARK: Use Button Action
    @objc private func useButtonAction(_ sender: UIButton) {
        self.view.applyCrossDissolveDismissAnimation(duration: 0.25, delay: 0.1, handler: { isEnd in
            if isEnd {
                self.dismiss(animated: isEnd) {
                    self.useMPINTapped?()
                }
            }
        })
    }
  
}

// MARK: Display logic
extension MPINSuccessViewController: MPINSuccessDisplayLogic {
    /* Display Biometric Status */
    func displayBiometricStatus(isFailed: Bool, alertData: AlertData?) {
        if !isFailed {
            if setMPINView == .verifyMPIN {
                self.dismiss(animated: true) {
                    self.biometricMatched?()
                }
            } else {
                biometricEnabled = true
                self.router?.routeToTabbarController()
            }
        } else {
            if setMPINView != .verifyMPIN {
                biometricEnabled = false
            }
            self.showMessageAlert(title: alertData?.alertTitle ?? "", message: alertData?.alertMessage ?? "", showRetry: false, cancelTitle: AppLoacalize.textString.okText, onRetry: nil, onCancel: nil)
        }
    }
    
    /* Display Setupview Date */
    func displaySetupViewDate(setMPINView: SetMPINView) {
        self.setMPINView = setMPINView
        if setMPINView == .verifyMPIN {
            self.mainSuccessBiometricView?.isHidden = true
            self.unlockBiometricView?.isHidden = false
            self.dimmedView?.isHidden = false
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                if context.biometryType == LABiometryType.faceID {
                    self.unlockBiometricImage?.image = UIImage(named: Image.imageString.faceid)
                    let descriptionLabelString = NSMutableAttributedString(string: AppLoacalize.textString.faceIDDescription)
                    descriptionLabelString.apply(color: UIColor.darkGreyDescriptionColor, subString: "Sign-in with Face ID", textFont: .setCustomFont(name: .medium, size: .x14))
                    self.unlockBiometricDescription?.attributedText = descriptionLabelString
                    
                } else {
                    self.unlockBiometricImage?.image = UIImage(named: Image.imageString.biometricColour)
                    self.unlockBiometricDescription?.text = AppLoacalize.textString.touchTheFingerprintSensor
                }
            }
            self.interactor?.callBiometric()
        } else {
            self.unlockBiometricView?.isHidden = true
            self.dimmedView?.isHidden = true
            self.mainSuccessBiometricView?.isHidden = false
        }
    }
}
