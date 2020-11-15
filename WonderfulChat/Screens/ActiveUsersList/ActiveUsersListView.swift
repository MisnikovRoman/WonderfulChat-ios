//
//  ActiveUsersListView.swift
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

struct ActiveUserCard: View {
    
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
    
    @ObservedObject
    var viewModel: ActiveUsersListViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(minimum: 10))]) {
                    ForEach(viewModel.activeUsers, id: \.self) { userName in
                        NavigationLink(destination: viewModel.go(to: .chat(User(name: userName)))) {
                            ActiveUserCard(userName: userName)
                        }
                    }
                }
            }
        
            Button(action: viewModel.testSendMessage) {
                HStack {
                    Image(systemName: "exclamationmark.bubble.fill")
                    Text("Send test message")
                }.padding(12)
                .background(Color(.systemGray))
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .padding()
        .navigationBarTitle("Active users")
        .navigationBarItems(
            leading: Text(viewModel.userName).foregroundColor(.gray),
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
            ActiveUserCard(userName: "Roman")
                .previewLayout(.sizeThatFits)
            NavigationView {
                ActiveUsersListView(
                    viewModel: ActiveUsersListViewModel(
                        authorizationService: MockAuthorizationService(),
                        chatService: MockChatService(),
                        viewFactory: MockViewFactory()))
            }
        }
    }
}
