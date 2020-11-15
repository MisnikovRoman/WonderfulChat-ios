//
//  ErrorViewModel.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 15.11.2020.
//

import Foundation

class ErrorViewModel: ObservableObject {

    let retry: (() -> Void)?
    
    init(retryAction: (() -> Void)? = nil) {
        self.retry = retryAction
    }
}
