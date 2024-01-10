//
//  GenericWebViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 17/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit

protocol GenericWebDisplayLogic: AnyObject {
    func displayUIAttributes(flowEnum: ModuleFlowEnum, urlString: String)
}

class GenericWebViewController: UIViewController, GenericWebDisplayLogic {
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var navigationTitleLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var genericWebView: WKWebView?
    var interactor: GenericWebBusinessLogic?
    var router: (NSObjectProtocol & GenericWebRoutingLogic & GenericWebDataPassing)?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getWebviewUIAttributes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView?.applyGradient(isVertical: true, colorArray: [.statusBarColor, .appDarkBlueColor])
    }

}

// MARK: Initial Setup
extension GenericWebViewController {
    // MARK: Initial Setup
    private func initializeUI(flowEnum: ModuleFlowEnum, url: String) {
        [genericWebView].forEach {
            $0?.navigationDelegate = self
            $0?.backgroundColor = .white
        }
        [navigationTitleLabel].forEach {
            $0?.textColor = .white
            $0?.font = .setCustomFont(name: .semiBold, size: .x18)
            $0?.text = AppLoacalize.textString.emailSettings
        }
        backButton?.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        customizeUI(flowEnum: flowEnum)
        loadWebViewWithUrl(url: url)
        avoidCopyfromBlock()
    }
    
    // MARK: Update title as per FlowEnum
    private func customizeUI(flowEnum: ModuleFlowEnum) {
        switch flowEnum {
        case .termsAndConditions:
            navigationTitleLabel?.text = AppLoacalize.textString.termsAndCondition
        case .kycPolicy:
            navigationTitleLabel?.text = AppLoacalize.textString.kycPolicy
        case .privacyPolicy:
            navigationTitleLabel?.text = AppLoacalize.textString.privacyPolicyRowTitle
        case .grievancePolicy:
            navigationTitleLabel?.text = AppLoacalize.textString.grievancePolicy
//        case .faq:
//            navigationTitleLabel?.text = AppLoacalize.textString.faq
        default:
            navigationTitleLabel?.text = AppLoacalize.textString.faq
        }
    }
    // MARK: Avoid Copy from Webview
    private func avoidCopyfromBlock() {
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: nil, action: nil)
        longPress.minimumPressDuration = 0.2
        genericWebView?.addGestureRecognizer(longPress)
    }
    
    // MARK: loadWebView With Url
    private func loadWebViewWithUrl(url: String) {
        let request = URLRequest(url: URL(string: url) ?? URL(fileURLWithPath: ""))
        self.genericWebView?.load(request)
    }
}

// MARK: Button action
extension GenericWebViewController {
    
    // MARK: Back Button action
    @objc private func backBtnAction() {
        self.dismissVC()
    }
}

// MARK: Display logic
extension GenericWebViewController {
    // MARK: Display UI Attributes
    func displayUIAttributes(flowEnum: ModuleFlowEnum, urlString: String) {
        initializeUI(flowEnum: flowEnum, url: urlString)
    }
}

// MARK: WKNavigationDelegate
extension GenericWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url, let scheme = url.scheme else {
            decisionHandler(.cancel)
            return
        }

        if (scheme.lowercased() == "mailto") || (scheme.lowercased() == "tel") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
