//
//  DebugView.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 08.11.2020.
//

import SwiftUI
import Combine

struct DebugView: View {

    @ObservedObject
    var viewModel: DebugViewModel
    
    var body: some View {
        Form {
            Section(header: Text(viewModel.endpointSectionHeader),
                    footer: Text(viewModel.endpointSectionFooter)) {

                Picker(selection: $viewModel.selectedEndpoint, label: Text(viewModel.pickerText)) {
                    ForEach(viewModel.availableEndpoints, id: \.element) { offset, item in
                        Text(item).tag(offset)
                    }
                }
            }
        }
        .navigationBarTitle("Debug")
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DebugView(
                viewModel: DebugViewModel(
                    settingsContainer: SettingContainer(),
                    chatService: MockChatService()))
        }
    }
}
