//
//  StartVideoKYCViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartVideoKYCDisplayLogic: AnyObject {
    func displayNotesList(list: [NotesListModel], flowEnum: ModuleFlowEnum)
    func displayVKYCScenes(vkycResponse: VKYCResponse?)
    func displayUserData(response: AccountDetailsRespone?)
}

class StartVideoKYCViewController: UIViewController {
    @IBOutlet private weak var navigationview: UIView?
    @IBOutlet private weak var navigationTitleLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var cardView: UIView?
    @IBOutlet private weak var notesListTableView: UITableView?
    @IBOutlet private weak var startVkycButton: UIButton?
    @IBOutlet private weak var doLaterLabel: UILabel?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet var cardViewHeightConstraint: NSLayoutConstraint?
    var interactor: StartVideoKYCBusinessLogic?
    var router: (NSObjectProtocol & StartVideoKYCRoutingLogic & StartVideoKYCDataPassing)?
    private var notesList = [NotesListModel]()
    private var flowEnum: ModuleFlowEnum?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.getUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationview?.applyGradient(isVertical: true, colorArray: [.statusBarColor, .appDarkBlueColor])
        cardView?.roundCorners(corners: .allCorners, radius: 20)
    }
}

// MARK: Initial Setup
extension StartVideoKYCViewController {
    /* Initial loads */
    private func initializeUI() {
        self.view.backgroundColor = .lightDisableBackgroundColor
        navigationTitleLabel?.text = AppLoacalize.textString.vkyc
        navigationTitleLabel?.textColor = .white
        navigationTitleLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
        
        titleLabel?.text = AppLoacalize.textString.videoVerification
        titleLabel?.textColor = .primaryColor
        titleLabel?.font = .setCustomFont(name: .semiBold, size: .x24)
        
        descriptionLabel?.text = AppLoacalize.textString.vkycSubTitle
        descriptionLabel?.textColor = .darkGray
        descriptionLabel?.font = .setCustomFont(name: .regular, size: .x16)
        
        let doLaterLabelAttributedString = NSMutableAttributedString(string: AppLoacalize.textString.doThisLater)
        doLaterLabelAttributedString.applyUnderLineText(subString: AppLoacalize.textString.doThisLater)
        self.doLaterLabel?.attributedText = doLaterLabelAttributedString
       
        cardView?.addLightShadow()
        startVkycButton?.setup(title: AppLoacalize.textString.startVideoKyc, type: .primary, isEnabled: true)
        
        initializeButtonActions()
        registerTableViewCell()
        interactor?.getUIContentList()
    }
    
    /* Initialize Button Actions */
    private func initializeButtonActions() {
        backButton?.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        startVkycButton?.addTarget(self, action: #selector(startKycButtonAction), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doLaterLabelAction(tapGestureRecognizer:)))
        doLaterLabel?.isUserInteractionEnabled = true
        doLaterLabel?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /* Register TableViewCell */
    private func registerTableViewCell() {
        notesListTableView?.delegate = self
        notesListTableView?.dataSource = self
        notesListTableView?.register(UINib(nibName: Cell.identifier.notesListTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.notesListTableViewCell)
    }
    
}

// MARK: Button Actions
extension StartVideoKYCViewController {
    
    /* Back Button Action */
    @objc private func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* StartKyc Button Action */
    @objc private func startKycButtonAction() {
        router?.routeToUserConsentVC()
    }
    
    /* DoLater Label Action */
    @objc private func doLaterLabelAction(tapGestureRecognizer: UITapGestureRecognizer) {
        self.popToViewController(destination: TabbarViewController.self)
    }
}

// MARK: UITableDelegate & Datasource
extension StartVideoKYCViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.notesListTableViewCell) as? NotesListTableViewCell
        cell?.updateData(data: self.notesList[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

// MARK: Display logic
extension StartVideoKYCViewController: StartVideoKYCDisplayLogic {
    
    // MARK: Display Notes list
    func displayNotesList(list: [NotesListModel], flowEnum: ModuleFlowEnum) {
        self.notesList = list
        self.flowEnum = flowEnum
        cardViewHeightConstraint?.constant = CGFloat(self.notesList.count * 80)
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.notesListTableView?.reloadData()
        }
    }
    
    // MARK: Display VKYC
    func displayVKYCScenes(vkycResponse: VKYCResponse?) {
        self.dismiss(animated: true, completion: {
            if let url =  URL(string: vkycResponse?.result?.vciplink ?? "") {
                UIApplication.shared.open(url)
            }
        })
    }
    
    func displayUserData(response: AccountDetailsRespone?) {
        if response?.result?.kycStatus == "COMPLETED" {
            self.popToViewController(destination: TabbarViewController.self)
        }
    }
}

// MARK: Router to Viewcontroller
extension StartVideoKYCViewController: PassDataToStartVideoKYC {
    func callVkycLink() {
        self.interactor?.fetchVKYCLink()
    }
}
