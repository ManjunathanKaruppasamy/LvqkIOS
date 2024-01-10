//
//  UploadDocumentPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UploadDocumentPresentationLogic {
    func presentFieldDetails(documentDetailsField: [DocumentDetailsField])
}

class UploadDocumentPresenter: UploadDocumentPresentationLogic {
    weak var viewController: UploadDocumentDisplayLogic?
    
    // MARK: present Field Details
    func presentFieldDetails(documentDetailsField: [DocumentDetailsField]) {
        self.viewController?.displayFieldDetails(documentDetailsField: documentDetailsField)
    }
}
