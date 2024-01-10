//
//  InstructionTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//

import UIKit

class InstructionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var viewContent: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet weak var instructionContentTableView: UITableView?
    
    var instructionDetailsModel: InstructionDetailsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Initial Setup
extension InstructionTableViewCell {
    private func initialLoad() {
        self.titleLabel?.textColor = .orangeColor
        self.titleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.viewContent?.layer.cornerRadius = 10
        self.setTableView()
    }
    // MARK: Tableview Setup
    private func setTableView() {
        self.instructionContentTableView?.register(UINib(nibName: Cell.identifier.instructionContentTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.instructionContentTableViewCell)
        self.instructionContentTableView?.delegate = self
        self.instructionContentTableView?.dataSource = self
        self.instructionContentTableView?.separatorStyle = .none
    }
}

// MARK: tableView delegate - datasource
extension InstructionTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.instructionDetailsModel?.instructionContentArray.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: InstructionContentTableViewCell = self.instructionContentTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.instructionContentTableViewCell, for: indexPath) as? InstructionContentTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        self.titleLabel?.text = self.instructionDetailsModel?.title
        cell.setUPData(title: self.instructionDetailsModel?.instructionContentArray[indexPath.row] ?? "", isTickImageEnable: self.instructionDetailsModel?.isTickImageEnable ?? true)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
