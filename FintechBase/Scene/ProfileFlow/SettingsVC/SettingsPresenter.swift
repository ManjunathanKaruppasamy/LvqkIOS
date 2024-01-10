//
//  SettingsPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SettingsPresentationLogic {
    func presentInitialData(response: Settings.Profile.Response)
    func presentContentData()
}

class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsDisplayLogic?
    
    // MARK: Pass data to viewcontroller
    func presentInitialData(response: Settings.Profile.Response) {
        let viewModel = Settings.Profile.ViewModel.init(profileList: response.profileList, userData: response.userData, userAccountDetailList: response.userAccountDetailList)
        viewController?.displayProfileData(viewModel: viewModel)
    }
    
    // MARK: Save data and connect to presenter
    func presentContentData() {
        viewController?.moveToAnotherVC()
    }
}
