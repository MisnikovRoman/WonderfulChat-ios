//
//  DebugViewModel.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 08.11.2020.
//

import Foundation
import Combine

class DebugViewModel: ObservableObject {
    
    private let settingsContainer: SettingContainer
    private let chatService: IChatService
    
    // Выбор эндпоинта для вебсокета
    let endpointSectionHeader = "Адрес сервера"
    let endpointSectionFooter = "Выберите к какому серверу будет осуществляться подлючение через WebSocket"
    let pickerText = "Сервер"
    lazy var availableEndpoints = settingsContainer.availableEndpoints
        .map { $0.rawValue }
        .enumerated()
        .toArray()
    @Published var selectedEndpoint = 0
    private var cancellable: AnyCancellable?
    
    init(settingsContainer: SettingContainer, chatService: IChatService) {
        self.settingsContainer = settingsContainer
        self.chatService = chatService
        setup()
        }
}

private extension DebugViewModel {
    func setup() {
        cancellable = $selectedEndpoint.sink { [weak self] newSelectionIndex in
            guard let self = self,
                  newSelectionIndex >= 0,
                  self.availableEndpoints.count > newSelectionIndex,
                  let host = API.Host(rawValue: self.availableEndpoints[newSelectionIndex].element)
            else { return }

            self.settingsContainer.selectedEndpoint = host
            self.chatService.disconnect()
        }
    }
}

extension Sequence {
    func toArray() -> Array<Element> {
        Array(self)
    }
}
