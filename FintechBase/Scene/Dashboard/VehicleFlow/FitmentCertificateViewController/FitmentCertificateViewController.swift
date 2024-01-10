//
//  FitmentCertificateViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit

protocol FitmentCertificateDisplayLogic: AnyObject {
    func displayFitmentData(viewModel: FitmentCertificate.FitmentCertificateModel.ViewModel, fitmentData: FitmentCertificateData?)
}

class FitmentCertificateViewController: UIViewController {
    var interactor: FitmentCertificateBusinessLogic?
    var router: (NSObjectProtocol & FitmentCertificateRoutingLogic & FitmentCertificateDataPassing)?
    
    @IBOutlet weak var navView: UIView?
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var navTitle: UILabel?
    @IBOutlet weak var mWKWebView: WKWebView?
    @IBOutlet weak var downloadFitmentButton: UIButton?
    @IBOutlet weak var sendMailButton: UIButton?
    @IBOutlet weak var vehicleNumberLabel: UILabel?
    @IBOutlet weak var certificateTitleLabel: UILabel?
    
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
extension FitmentCertificateViewController {
    func initialLoads() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setAction()
        self.mWKWebView?.navigationDelegate = self
        self.mWKWebView?.isHidden = true
        self.interactor?.getFitmentData(sendEmail: false)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.navTitle?.text = AppLoacalize.textString.tagFitmentCertificate
        self.certificateTitleLabel?.text = AppLoacalize.textString.tagFitmentCertificate
    }
    
    // MARK: Font
    private func setFont() {
        self.navTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.vehicleNumberLabel?.font = UIFont.setCustomFont(name: .regular, size: .x18)
        self.certificateTitleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Color
    private func setColor() {
        self.navTitle?.textColor = .white
        self.vehicleNumberLabel?.textColor = .primaryColor
        self.certificateTitleLabel?.textColor = .primaryColor
    }
    
    // MARK: Set Action
    private func setAction() {
        self.downloadFitmentButton?.setup(title: AppLoacalize.textString.download, type: .primary, isEnabled: true)
        self.sendMailButton?.setup(title: AppLoacalize.textString.sendAnEmail, type: .secondary, isEnabled: true)
        
        self.downloadFitmentButton?.addTarget(self, action: #selector(downloadFitmentButtonAction(_:)), for: .touchUpInside)
        self.sendMailButton?.addTarget(self, action: #selector(sendMailButtonAction(_:)), for: .touchUpInside)
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        
    }
    
    // MARK: Download Fitment Button Action
    @objc private func downloadFitmentButtonAction(_ sender: UIButton) {
        self.interactor?.convertandSavePdfToDevice(webview: self.mWKWebView)
    }
    
    // MARK: Send Mail Button Action
    @objc private func sendMailButtonAction(_ sender: UIButton) {
        self.interactor?.getFitmentData(sendEmail: true)
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: WKNavigationDelegate Methods
extension FitmentCertificateViewController: WKNavigationDelegate {
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        showLoader()
    }
    
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        hideLoader()
        self.mWKWebView?.isHidden = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // if the request is a non-http(s) schema, then have the UIApplication handle
        // opening the request
        //        if let url = navigationAction.request.url, !url.absoluteString.hasPrefix("http://"), !url.absoluteString.hasPrefix("https://"), UIApplication.shared.canOpenURL(url) {
        //            // have UIApplication handle the url (sms:, tel:, mailto:, ...)
        //            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //            // cancel the request (handled by UIApplication)
        //            decisionHandler(.cancel)
        //        } else {
        // allow the request
        decisionHandler(.allow)
        //  }
    }
}

// MARK: - DisplayLogic
extension FitmentCertificateViewController: FitmentCertificateDisplayLogic {
    /* Display Fitment Data */
    func displayFitmentData(viewModel: FitmentCertificate.FitmentCertificateModel.ViewModel, fitmentData: FitmentCertificateData?) {
        
        self.vehicleNumberLabel?.text = fitmentData?.vehicleNumber ?? ""
        let baseURL = viewModel.fitmentCertificateData?.result ?? ""
        let sendEmail = viewModel.sendEmail ?? false
        if sendEmail {
            showSuccessToastMessage(message: AppLoacalize.textString.emailSendSuccess, messageColor: .white, bgColour: UIColor.greenTextColor)
        } else {
            if let decodeData = Data(base64Encoded: baseURL, options: .ignoreUnknownCharacters) {
                self.mWKWebView?.load(decodeData, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: URL(fileURLWithPath: ""))
            }
        }
    }
}
