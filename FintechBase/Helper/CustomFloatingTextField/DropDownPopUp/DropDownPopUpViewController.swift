//
//  DropDownPopUpViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/08/22.
//

import UIKit

class DropDownPopUpViewController: UIViewController {
    
    @IBOutlet weak var viewContentHeight: NSLayoutConstraint?
    @IBOutlet var dimmedView: UIView?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var dropDownListTableView: UITableView?
    @IBOutlet weak var dropDownListHeaderLabel: UILabel?
    
    var selectedOption: ((String, Int) -> Void)?
    var onClose: (() -> Void)?
    var dropDownArray = [String]()
    var headerName = ""
    var isOnlyOneTitle: Bool = true // If condition is true means it will show only one title
    var dropDownWithImageArray = [FastTagResultList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialLoads()
    }
}

// MARK: Initial Set Up
extension DropDownPopUpViewController {
    // MARK: Initial Load
    private func initialLoads() {
        self.setTableView()
        self.setColor()
        self.setFont()
        self.viewContent?.layer.cornerRadius = 15
        self.dimmedView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTapped)))
        if isOnlyOneTitle {
            self.viewContentHeight?.constant = CGFloat((dropDownArray.count * 45) + 55)
        } else {
            self.viewContentHeight?.constant = CGFloat((dropDownWithImageArray.count * 65) + 55)
        }
    }
    
    // MARK: Close Action
    @objc func closeTapped() {
        onClose?()
        self.dismiss(animated: false)
    }
    
    // MARK: Color
    private func setColor() {
        dropDownListHeaderLabel?.textColor = .primaryColor
    }
    
    // MARK: Font
    private func setFont() {
        dropDownListHeaderLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
    }
    
    // MARK: Set Table View
    private func setTableView() {
        if let dropDownListTableView = dropDownListTableView {
            let nib = UINib(nibName: Cell.identifier.dropDownTableViewCell, bundle: nil)
            dropDownListTableView.register(nib, forCellReuseIdentifier: Cell.identifier.dropDownTableViewCell)
            dropDownListTableView.delegate = self
            dropDownListTableView.dataSource = self
            dropDownListTableView.allowsSelection = true
            dropDownListTableView.allowsSelectionDuringEditing = true
        }
    }
    
}

// MARK: TableViewDelegate & TableViewDataSource
extension DropDownPopUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isOnlyOneTitle ? (dropDownArray.count) : (dropDownWithImageArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.dropDownTableViewCell, for: indexPath) as? DropDownTableViewCell
        
        cell?.setDropDownSetUp(isOnlyTitle: isOnlyOneTitle)
        if isOnlyOneTitle {
            dropDownListHeaderLabel?.text = headerName
            cell?.dropDownListLabel?.text = dropDownArray[indexPath.item]
        } else {
            dropDownListHeaderLabel?.text = AppLoacalize.textString.vehicleClass
            cell?.dropDownListLabel?.text = dropDownWithImageArray[indexPath.row].title
            cell?.dropDownSecondLabel?.text = dropDownWithImageArray[indexPath.row].tagClass
            cell?.dropDownImage?.image = dropDownWithImageArray[indexPath.row].image?.base64StringToImage()
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isOnlyOneTitle ? 45 : 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isOnlyOneTitle {
            self.selectedOption?(dropDownArray[indexPath.item], indexPath.item)
        } else {
            self.selectedOption?(dropDownWithImageArray[indexPath.item].title ?? "", indexPath.item)
        }
        self.dismiss(animated: false)
    }
    
}
