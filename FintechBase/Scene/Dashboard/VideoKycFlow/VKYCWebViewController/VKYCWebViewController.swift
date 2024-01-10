//
//  VKYCWebViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/05/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit

protocol VKYCWebDisplayLogic: AnyObject {
    func displayLoadLink(linkString: String)
}

class VKYCWebViewController: UIViewController {
  var interactor: VKYCWebBusinessLogic?
  var router: (NSObjectProtocol & VKYCWebRoutingLogic & VKYCWebDataPassing)?
  @IBOutlet private weak var vkycWebView: WKWebView?
  private var successFailurePopUpView = SuccessFailurePopUpView()
    
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
      self.initialLoads()
  }
}

// MARK: Initial Set Up
extension VKYCWebViewController {
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.vkycWebView?.navigationDelegate = self
        self.interactor?.getVideoKYCurl()
    }
}

extension VKYCWebViewController {
    
    // MARK: Present Success FailurePopUpView
    func presentSuccessFailurePopUpView(status: String) {
        self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height ))
            self.successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.vkycCompletedSuccessfully, description: AppLoacalize.textString.vkycCompletedDescription, image: Image.imageString.successTick, primaryButtonTitle: AppLoacalize.textString.backToHome, isCloseButton: true))
        self.successFailurePopUpView.onClickClose = { value in
            self.successFailurePopUpView.removeFromSuperview()
                self.router?.routeToDashboard()
        }
        self.view.addSubview(self.successFailurePopUpView)
    }
}

// MARK: WKNavigationDelegate Methods
extension VKYCWebViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            showLoader()
            self.vkycWebView?.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        hideLoader()
        if let text = webView.url?.absoluteString, text.contains(vkycCallBack) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.vkycWebView?.isHidden = true
                self.presentSuccessFailurePopUpView(status: text)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoader()
        showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong)
        self.dismiss(animated: false)
    }
}

// MARK: - DisplayLogic
extension VKYCWebViewController: VKYCWebDisplayLogic {
    /* Display VKYC Link */
    func displayLoadLink(linkString: String) {
        let request = URLRequest(url: URL(string: linkString) ?? URL(fileURLWithPath: ""))
        self.vkycWebView?.load(request)
    }
}
