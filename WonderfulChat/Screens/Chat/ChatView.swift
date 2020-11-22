//
//  ContentView.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

import SwiftUI

// MARK: - Message cell
struct MessageCell: View {
    let message: MessageViewModel
    
    private let myMessagesColor = Color.blue
    private let otherMessagesColor = Color.gray

    var body: some View {
        HStack {
            if message.isMyMessage { Spacer() }
            Text(message.text)
                .foregroundColor(.white)
                .padding(8)
                .background(message.isMyMessage ? myMessagesColor : otherMessagesColor)
                .cornerRadius(8)
            if !message.isMyMessage { Spacer() }
        }
    }
}

// MARK: - New message
struct NewMessageView: View {
    @Binding
    var newMessage: String
    var sendAction: () -> ()

    var body: some View {
        HStack {
            TextField("Введите сообщение", text: $newMessage)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
                .background(Color(UIColor.systemGray4))
                .cornerRadius(8)
                .lineLimit(4)
            Button(action: sendAction) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
}

// MARK: - Chat
struct ChatView: View {
    
    @ObservedObject
    var viewModel: ChatViewModel

    var body: some View {
        VStack(spacing: 16) {
            // TODO: ⚠️ Сделать отдельный компонент для перевернутого скролвью
            //https://www.hackingwithswift.com/books/ios-swiftui/scrollview-effects-using-geometryreader
            //https://www.process-one.net/blog/writing-a-custom-scroll-view-with-swiftui-in-a-chat-application/
            ScrollView {
                ForEach(viewModel.messages) { message in
                    MessageCell(message: message)
                }
            }
            
            NewMessageView(
                newMessage: $viewModel.newMessage,
                sendAction: viewModel.sendMessage)
        }
        .navigationBarTitle(viewModel.interlocutor.name)
        .padding()
        .sheet(isPresented: $viewModel.haveUnhandledError, content: {
            viewModel.route(to: .error(NSError(domain: "123", code: 123, userInfo: nil)))
        })
    }
}

// MARK: -  Previews
struct ContentView_Previews: PreviewProvider {
    private static let user = User(name: "Test")
    static var previews: some View {
        Group {
            MessageCell(message: MessageViewModel(text: "Hello world", isMyMessage: true))
                .previewLayout(.sizeThatFits)
            MessageCell(message: MessageViewModel(text: "Lorem ipsum dolor", isMyMessage: false))
                .previewLayout(.sizeThatFits)
            NewMessageView(newMessage: .constant(""), sendAction: { print("📨 Sending") })
                .previewLayout(.sizeThatFits)
            NavigationView {
                ChatView(
                    viewModel: ChatViewModel(
                        user: User(name: "Test"),
                        authorizationService: MockAuthorizationService(),
                        chatService: MockChatService(),
                        viewFactory: MockViewFactory()))
            }
        }
    }
}

