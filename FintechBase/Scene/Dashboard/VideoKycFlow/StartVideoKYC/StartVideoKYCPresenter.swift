//
//  StartVideoKYCPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartVideoKYCPresentationLogic {
    func presentNotesList(list: [NotesListModel], flowEnum: ModuleFlowEnum)
    func presentVKYCScenes(vkycResponse: VKYCResponse?)
    func presentUserData(response: AccountDetailsRespone?)
}

class StartVideoKYCPresenter: StartVideoKYCPresentationLogic {
  weak var viewController: StartVideoKYCDisplayLogic?
  
  // MARK: Present NotesList
    func presentNotesList(list: [NotesListModel], flowEnum: ModuleFlowEnum) {
        viewController?.displayNotesList(list: list, flowEnum: flowEnum)
    }
    // MARK: Present VKYC
    func presentVKYCScenes(vkycResponse: VKYCResponse?) {
        self.viewController?.displayVKYCScenes(vkycResponse: vkycResponse)
    }
    func presentUserData(response: AccountDetailsRespone?) {
        viewController?.displayUserData(response: response)
    }
}
