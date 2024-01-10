//
//  LogoutViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 20/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LogoutDisplayLogic: AnyObject {
  func displaySomething(viewModel: Logout.Something.ViewModel)
}

class LogoutViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var subTitleLabel: UILabel?
    @IBOutlet private weak var lockAppButton: UIButton?
    @IBOutlet private weak var logoutButton: UIButton?
    @IBOutlet private weak var bgView: UIView?
    @IBOutlet private weak var bgImageView: UIImageView?
  var interactor: LogoutBusinessLogic?
  var router: (NSObjectProtocol & LogoutRoutingLogic & LogoutDataPassing)?
  
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
      initializeUI()
  }
    
  override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
      self.view.applyCrossDissolvePresentAnimation(duration: 0.7, delay: 0.1)
  }
    
  override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      self.bgView?.roundCorners(corners: [.topLeft, .topRight], radius: 10)
  }
}

// MARK: Initial Setup
extension LogoutViewController {
    /* Initial loads */
    private func initializeUI() {
        [titleLabel].forEach {
            $0?.textColor = .primaryColor
            $0?.font = .setCustomFont(name: .semiBold, size: .x18)
            $0?.text = AppLoacalize.textString.logoutTitle
        }
        
        [subTitleLabel].forEach {
            $0?.textColor = .darkGreyDescriptionColor
            $0?.font = .setCustomFont(name: .regular, size: .x16)
            $0?.text = AppLoacalize.textString.logoutSubTitle
        }
        
        [lockAppButton].forEach {
            $0?.setup(title: AppLoacalize.textString.lockApp, type: .primary, isEnabled: true)
            $0?.tintColor = .clear
            $0?.addTarget(self, action: #selector(logAppBtnAction), for: .touchUpInside)
            $0?.isHidden = true
        }
        
        [logoutButton].forEach {
            $0?.setup(title: AppLoacalize.textString.logout, type: .primary, isEnabled: true)
            $0?.addTarget(self, action: #selector(logOutBtnAction), for: .touchUpInside)
            $0?.tintColor = .clear
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAction(tapGestureRecognizer:)))
        bgImageView?.isUserInteractionEnabled = true
        bgImageView?.addGestureRecognizer(tapGestureRecognizer)
        bgImageView?.alpha = 0.5
        bgImageView?.isUserInteractionEnabled = true
    }
}

// MARK: Button Actions
extension LogoutViewController {
    
    // MARK: LogApp Button Action
    @objc private func logAppBtnAction() {
    }
    
    // MARK: Logout Button Action
    @objc private func logOutBtnAction() {
        router?.routeToInitialUserFlow()
    }
    
    // MARK: Background ImageView Action
    @objc private func dismissAction(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.applyCrossDissolveDismissAnimation(duration: 0.2, handler: { isDone in
            if isDone {
                self.dismissVC()
            }
        })
    }
}

// MARK: Display logic
extension LogoutViewController: LogoutDisplayLogic {
    func displaySomething(viewModel: Logout.Something.ViewModel) {
      
    }
}
