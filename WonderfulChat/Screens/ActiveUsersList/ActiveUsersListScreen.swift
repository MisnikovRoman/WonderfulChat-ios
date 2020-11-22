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

struct ActiveUserCardView: View {
    
    @State var userName: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
            Text(userName)
                .font(.title2)
            Spacer()
        }
        .padding()
        .background(Color(UIColor.darkGray))
        .foregroundColor(.white)
        .cornerRadius(16)
    }
}

struct ActiveUsersListView: View {
    @ObservedObject var viewModel: ActiveUsersListViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(minimum: 10))]) {
                    ForEach(viewModel.activeUsers, id: \.self) { user in
                        NavigationLink(destination: viewModel.go(to: .chat(user))) {
                            ActiveUserCardView(userName: user.name)
                        }
                    }
                }
            }

            Button(action: viewModel.testSendMessage) {
                HStack {
                    Image(systemName: "exclamationmark.bubble.fill")
                    Text("Send test message")
                }
                .padding(12)
                .background(Color(.systemGray))
                .foregroundColor(.white)
                .cornerRadius(20)
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

struct ActiveUsersListScreen: View {
    
    @ObservedObject var viewModel: ActiveUsersListViewModel
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                Text("Loading")
            case .userList:
                ActiveUsersListView(viewModel: viewModel)
            case .error:
                ErrorView(viewModel: ErrorViewModel(retryAction: viewModel.retryConnection))
            }
        }
        .padding()
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
            ActiveUserCardView(userName: "Roman")
                .previewLayout(.sizeThatFits)
            NavigationView {
                ActiveUsersListScreen(
                    viewModel: ActiveUsersListViewModel(
                        authorizationService: MockAuthorizationService(),
                        chatService: MockChatService(),
                        viewFactory: MockViewFactory()))
            }
        }
    }
}
