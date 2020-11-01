//
//  ActiveUsersList.swift
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

struct ActiveUsersList: View {
    
    private let chatService = ChatService()
    @State var userNames: [String] = []
    @EnvironmentObject var user: User
    
    var body: some View {
        ScrollView {
            ForEach(userNames, id: \.self) { userName in
                ActiveUserCard(userName: userName)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitle("Active users")
        .onAppear {
            chatService.connect(userId: user.id.uuidString, userName: user.name)
        }.onReceive(chatService.activeUsersPublisher.receive(on: RunLoop.main)) { users in
            userNames = users
        }.onDisappear {
            chatService.disconnect()
        }
    }
}

struct ActiveUsersList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActiveUserCard(userName: "Roman")
                .previewLayout(.sizeThatFits)
            NavigationView {
                ActiveUsersList()
            }
        }
    }
}
