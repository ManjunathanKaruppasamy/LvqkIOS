//
//  PayUViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 24/04/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit

protocol PayUDisplayLogic: AnyObject {
  func displayLoadLink(linkString: String, isAccountClose: Bool)
}

class PayUViewController: UIViewController {
    
    @IBOutlet private weak var payUwebView: WKWebView?
    
    var interactor: PayUBusinessLogic?
    var router: (NSObjectProtocol & PayURoutingLogic & PayUDataPassing)?
    private var successFailurePopUpView = SuccessFailurePopUpView()
    private var isAccountClose: Bool = false
    var payUStatus: ((Bool) -> Void)?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
}

extension PayUViewController {
    
    // MARK: Present Success FailurePopUpView
    func presentSuccessFailurePopUpView(status: String) {
        self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height ))
        if status.contains(PayUResult.status.success) {
            successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.paymentSuccess, description: AppLoacalize.textString.paymentSuccessDescription, image: Image.imageString.successTick, primaryButtonTitle: AppLoacalize.textString.okText))
        } else if status.contains(PayUResult.status.failure) {
            successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.paymentFailure, description: AppLoacalize.textString.paymentFailureDesription, image: Image.imageString.failureClose, primaryButtonTitle: AppLoacalize.textString.tryOtherPaymentOption))
        }
        self.successFailurePopUpView.onClickClose = { value in
            self.successFailurePopUpView.removeFromSuperview()
            if self.isAccountClose {
                self.dismiss(animated: false) {
                    self.payUStatus?(status.contains(PayUResult.status.success))
                }
            } else {
                if status.contains(PayUResult.status.success) {
                    self.router?.routeToDashboard()
                } else {
                    self.router?.routeToAddMoney()
                }
            }
        }
        self.view.addSubview(self.successFailurePopUpView)
    }
}

// MARK: Initial Set Up
extension PayUViewController {
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.payUwebView?.navigationDelegate = self
        self.interactor?.getLoadLink()
    }
}

// MARK: - DisplayLogic
extension PayUViewController: PayUDisplayLogic {
    /* Display PayU Entry link */
    func displayLoadLink(linkString: String, isAccountClose: Bool) {
        showLoader()
        self.isAccountClose = isAccountClose
        self.payUwebView?.isHidden = false
        let request = URLRequest(url: URL(string: linkString) ?? URL(fileURLWithPath: ""))
        self.payUwebView?.load(request)
    }
}

// MARK: WKNavigationDelegate Methods
extension PayUViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        hideLoader()
        print("absoluteString-->", webView.url?.absoluteString)
        if let text = webView.url?.absoluteString, text.contains(PayUResult.status.success) || text.contains(PayUResult.status.failure) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.payUwebView?.isHidden = true
                self.presentSuccessFailurePopUpView(status: text)
            }
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("url.........\(navigationAction.request.url)")
        
        if let url = navigationAction.request.url,
           !url.absoluteString.hasPrefix("http://"),
           !url.absoluteString.hasPrefix("https://"),
           UIApplication.shared.canOpenURL(url) {
            // have UIApplication handle the url (sms:, tel:, mailto:, ...)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("errorr--->>", error.localizedDescription)
        hideLoader()
        showSuccessToastMessage(message: error.localizedDescription)
//        self.dismiss(animated: false)
    }
}
