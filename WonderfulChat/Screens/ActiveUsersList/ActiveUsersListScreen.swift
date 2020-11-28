//
//  ActiveUsersListScreen.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import SwiftUI

struct ExitButton: View {
    let title: String
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.left.square")
                Text(title)
            }
        }
    }
}

struct UserStatusView: View {
    let name: String
    let state: ActiveUsersListViewModel.State
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(color)
            Text(name)
                .foregroundColor(.gray)
        }
    }
    
    private var color: Color {
        switch state {
        case .loading:
            return .gray
        case .userList:
            return .green
        case .error:
            return .red
        }
    }
}

struct ActiveUsersListView: View {
    @ObservedObject var viewModel: ActiveUsersListViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.activeUsers) { userViewModel in
                    ActiveUserCardView(viewModel: userViewModel)
                        .navigateToChat(with: viewModel)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

extension ActiveUserCardView {
    func navigateToChat(with screenViewModel: ActiveUsersListViewModel) -> NavigationLink<ActiveUserCardView, AnyView> {
        let user = screenViewModel.user(for: self.viewModel)
        let chatModule = screenViewModel.go(to: .chat(user))
        return NavigationLink(destination: chatModule) { self }
    }
}

struct ActiveUsersListScreen: View {
    
    @ObservedObject var viewModel: ActiveUsersListViewModel
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
            case .userList:
                ActiveUsersListView(viewModel: viewModel)
            case .error:
                ErrorView(viewModel: ErrorViewModel(retryAction: viewModel.retryConnection))
            }
        }
        .navigationBarTitle("Active users")
        .navigationBarItems(
            leading: UserStatusView(name: viewModel.userName, state: viewModel.viewState),
            trailing: ExitButton(title: "Log out", action: viewModel.logout))
        .onAppear(perform: viewModel.didAppear)
        .onDisappear(perform: viewModel.didDisappear)
        .fullScreenCover(isPresented: $viewModel.isNotAuthorized) {
            viewModel.go(to: .authorization)
        }
    }
}

struct ActiveUsersList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ActiveUsersListScreen(
                    viewModel: ActiveUsersListViewModel(
                        authorizationService: MockAuthorizationService(),
                        chatService: MockChatService(),
                        viewFactory: MockViewFactory()))
            }
            NavigationView {
                LoadingView()
            }
            NavigationView {
                ErrorView(viewModel: ErrorViewModel(retryAction: {}))
            }
        }
    }
}
