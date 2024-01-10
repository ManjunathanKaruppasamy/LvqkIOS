//
//  CustomerSupportViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 06/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CustomerSupportDisplayLogic: AnyObject {
    func displaySupportListData(response: [CusSupportModel], flowEnum: ModuleFlowEnum)
}

class CustomerSupportViewController: UIViewController {
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var navigationTitleLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var cussupportListTableView: UITableView?
    @IBOutlet private weak var headerView: UIView?
    var interactor: CustomerSupportBusinessLogic?
    var router: (NSObjectProtocol & CustomerSupportRoutingLogic & CustomerSupportDataPassing)?
    var supportlist = [CusSupportModel]()
    private var flowEnum: ModuleFlowEnum = .none
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizeUI()
        registerTableView()
        getSupportListData()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationView?.applyGradient(isVertical: true, colorArray: [.statusBarColor, .appDarkBlueColor])
    }
}

// MARK: Initial Set Up
extension CustomerSupportViewController {
    
    // MARK: Initial loads
    private func initilizeUI() {
        navigationController?.navigationBar.isHidden = true
        headerView?.backgroundColor = .statusBarColor
        [navigationTitleLabel].forEach {
            $0?.textColor = .white
            $0?.font = .setCustomFont(name: .semiBold, size: .x18)
            $0?.text = AppLoacalize.textString.customerSupport
        }
        
        backButton?.addTarget(self, action: #selector(backToVC), for: .touchUpInside)
        self.view.backgroundColor = .whitebackgroundColor
    }
    
    // MARK: RegisterTableView
    private func registerTableView() {
        cussupportListTableView?.delegate = self
        cussupportListTableView?.dataSource = self
        cussupportListTableView?.separatorStyle = .none
        cussupportListTableView?.backgroundColor = .clear
        cussupportListTableView?.register(UINib(nibName: Cell.identifier.supportListTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.supportListTableViewCell)
    }
}

// MARK: UITableViewDelegate & DataSource
extension CustomerSupportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        supportlist.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        supportlist[section].list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.supportListTableViewCell) as? SupportListTableViewCell
        cell?.uplaodData(data: supportlist[indexPath.section].list?[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 5, width: headerView.frame.width-32, height: headerView.frame.height-10)
        label.text = supportlist[section].name
        label.font = .setCustomFont(name: .semiBold, size: .x16)
        label.textColor = .darkGray
        headerView.addSubview(label)
        headerView.backgroundColor = .white
        headerView.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 24))
        footerView.backgroundColor = .white
        footerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        return footerView
    }
}

// MARK: Button actions
extension CustomerSupportViewController {
    
    // MARK: Back action
    @objc private func backToVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Interacter Requests
extension CustomerSupportViewController {
    /* Get Support List Data */
    private func getSupportListData() {
        interactor?.loadSupportListData()
    }
}

// MARK: Display Logic
extension CustomerSupportViewController: CustomerSupportDisplayLogic {
    
    // MARK: Display SupportListData
    func displaySupportListData(response: [CusSupportModel], flowEnum: ModuleFlowEnum) {
        self.supportlist = response
        self.flowEnum = flowEnum
        DispatchQueue.main.async {
            self.cussupportListTableView?.reloadData()
        }
        navigationTitleLabel?.text = AppLoacalize.textString.customerSupport
    }
}
