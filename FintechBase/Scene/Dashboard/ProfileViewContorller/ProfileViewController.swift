//
//  ProfileViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
  func displaySomething(viewModel: Profile.Something.ViewModel)
}

class ProfileViewController: UIViewController, ProfileDisplayLogic {
  var interactor: ProfileBusinessLogic?
  var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
  
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    doSomething()
  }
  
  // MARK: Do something
  // @IBOutlet weak var nameTextField: UITextField!
  
  func doSomething() {
    let request = Profile.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: Profile.Something.ViewModel) {
    // nameTextField.text = viewModel.name
  }
}
