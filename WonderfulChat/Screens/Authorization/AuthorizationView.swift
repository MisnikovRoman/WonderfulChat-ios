//
//  AuthorizationView.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import SwiftUI

struct AuthorizationView: View {
    
    @ObservedObject
    var viewModel: AuthorizationViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                TextField("name", text: $viewModel.enteredUserName)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                VStack {
                    Spacer()
                    Button("Continue", action: viewModel.login)
                        .disabled(!viewModel.isLoginButtonEnabled)
                }
            }
            .padding(32)
            .navigationBarTitle("Introduce yourself")
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(
            viewModel: AuthorizationViewModel(
                authorizationService: MockAuthorizationService()))
    }
}
