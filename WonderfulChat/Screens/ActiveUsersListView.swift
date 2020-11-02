//
//  ActiveUsersListView.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import SwiftUI

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
    
    private let chatService: IChatService
    private let user: User
    
    @EnvironmentObject
    private var factory: ViewFactory
    @State
    private var userNames: [String] = []
    
    init(chatService: IChatService, user: User) {
        self.chatService = chatService
        self.user = user
    }
    
    var body: some View {
        List {
            ForEach(userNames, id: \.self) { userName in
                NavigationLink(destination: ChatView()) {
                    ActiveUserCard(userName: userName)
                }
            }
        }
        .navigationBarTitle("Active users")
        .onAppear {
            chatService.connect(userId: user.id.uuidString, userName: user.name)
        }.onReceive(chatService.activeUsersPublisher.receive(on: RunLoop.main)) { users in
            userNames = users
        }
    }
}

struct ActiveUsersList_Previews: PreviewProvider {
    
    static let mockUser: User = {
        let user = User()
        user.name = "Roman"
        return user
    }()

    static var previews: some View {
        Group {
            ActiveUserCard(userName: "Roman")
                .previewLayout(.sizeThatFits)
            NavigationView {
                ActiveUsersListView(chatService: MockChatService(), user: mockUser)
            }
            NavigationView {
                ActiveUsersListView(chatService: MockChatService(), user: mockUser)
            }.environment(\.colorScheme, .dark)
        }
    }
}
