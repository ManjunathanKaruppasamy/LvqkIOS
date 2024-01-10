//
//  TrackIssueViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 07/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TrackIssueDisplayLogic: AnyObject {
  func displayTrackIssueData(data: [DisputeEntityResult]?)
}

class TrackIssueViewController: UIViewController, TrackIssueDisplayLogic {
    
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var navigationTitleLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var segmentControl: M2PSegmentedControl?
    @IBOutlet private weak var trackListTableView: UITableView?
    @IBOutlet private weak var headerView: UIView?
    @IBOutlet private weak var segmentControlView: UIView?
    @IBOutlet private weak var openSegmentButton: UIButton?
    @IBOutlet private weak var closedSegmentButton: UIButton?
    
    private var trackList = [DisputeEntityResult]()
    private var filterTrackList = [DisputeEntityResult]()
    
  var interactor: TrackIssueBusinessLogic?
  var router: (NSObjectProtocol & TrackIssueRoutingLogic & TrackIssueDataPassing)?
  
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
      initializeUI()
      setDelegates()
      getTrackIssueList()
  }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationView?.applyGradient(isVertical: true, colorArray: [.statusBarColor, .appDarkBlueColor])
    }

}

// MARK: Initial setup
extension TrackIssueViewController {
    // MARK: initializeUI
     private  func initializeUI() {
          navigationController?.navigationBar.isHidden = true
          headerView?.backgroundColor = .statusBarColor
          [navigationTitleLabel].forEach {
              $0?.text = AppLoacalize.textString.trackIssue
              $0?.textColor = .white
              $0?.font = .setCustomFont(name: .semiBold, size: .x18)
          }
          
          backButton?.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
          self.view.backgroundColor = .whitebackgroundColor
          self.initializeSegmentControl()
      }
    
    // MARK: Initialize tableview
     private func setDelegates() {
          trackListTableView?.delegate = self
          trackListTableView?.dataSource = self
          trackListTableView?.separatorStyle = .none
          trackListTableView?.backgroundColor = .clear
          trackListTableView?.register(UINib(nibName: Cell.identifier.trackListTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.trackListTableViewCell)
      }
    
    /* Initialize SegmentControl */
    private func initializeSegmentControl() {
        var segmentColor = M2PSegmentColorConfiguration()
        segmentColor.thumbColor = UIColor.white
        segmentColor.backGroundColor = UIColor.lightDisableBackgroundColor
        segmentColor.selectedLabelColor = UIColor.primaryColor
        segmentColor.unselectedLabelColor = UIColor.primaryColor.withAlphaComponent(0.4)
        segmentColor.borderColor = UIColor.lightDisableBackgroundColor
        
        self.segmentControl?.items = [AppLoacalize.textString.open, AppLoacalize.textString.closed]
        self.segmentControl?.m2pSegmentConfiguration(font: .setCustomFont(name: .semiBold, size: .x14), cornerRadius: 16, color: segmentColor)
        self.segmentControl?.selectedIndex = 0
        self.segmentControl?.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension TrackIssueViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterTrackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier.trackListTableViewCell) as? TrackListTableViewCell
        cell?.configureTrackListData(data: self.filterTrackList[indexPath.row])
        cell?.selectionStyle = .none
        cell?.addLightShadow()
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 25

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 12
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
}

// MARK: Button actions
extension TrackIssueViewController {
    
    // MARK: Back actions
    @objc private func backBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Segment control actions
    @objc private func segmentedControlValueChanged() {
        switch self.segmentControl?.selectedIndex {
        case 0:
            self.filterTrackList = self.trackList.filter({ $0.status?.lowercased() != TrackIssueStatus.status.resolved })
        case 1 :
            self.filterTrackList = self.trackList.filter({ $0.status?.lowercased() == TrackIssueStatus.status.resolved })
        default:
            break
        }
        self.trackListTableView?.reloadInMainThread()
    }
}

// MARK: Interacter Requests
extension TrackIssueViewController {
    /* Get TrackIssueList */
    private func getTrackIssueList() {
        interactor?.loadTrackIssueList()
    }
}

// MARK: Display Logic
extension TrackIssueViewController {
    
    // MARK: Display TrackIssueData
    func displayTrackIssueData(data: [DisputeEntityResult]?) {
        self.trackList = data ?? [DisputeEntityResult]()
        self.filterTrackList = self.trackList.filter({ $0.status?.lowercased() != TrackIssueStatus.status.resolved })
        self.trackListTableView?.reloadInMainThread()
        
    }
}
