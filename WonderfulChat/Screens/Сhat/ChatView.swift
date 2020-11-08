//
//  ContentView.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

import SwiftUI

// MARK: - Message cell
struct MessageCell: View {
    let message: Message
    
    private let myMessagesColor = Color.blue
    private let otherMessagesColor = Color.gray

    var body: some View {
        HStack {
            if isMyMessage { Spacer() }
            Text(message.text)
                .foregroundColor(.white)
                .padding(8)
                .background(isMyMessage ? myMessagesColor : otherMessagesColor)
                .cornerRadius(8)
            if !isMyMessage { Spacer() }
        }
    }
}

private extension MessageCell {
    var isMyMessage: Bool {
        message.sender == .myself
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
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: sendAction) {
                Image(systemName: "paperplane.fill")
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
                    ForEach(viewModel.messages, id: \.self) { message in
                        MessageCell(message: message)
                    }
                }
                
                NewMessageView(
                    newMessage: $viewModel.newMessage,
                    sendAction: viewModel.sendMessage)
            }
            .navigationBarTitle(viewModel.user.name)
            .padding()
    }
}

// MARK: -  Previews
struct ContentView_Previews: PreviewProvider {
    private static let user = User(name: "Test")
    static var previews: some View {
        Group {
            MessageCell(message: Message(text: "Hello world", sender: .myself))
                .previewLayout(.sizeThatFits)
            MessageCell(message: Message(text: "Lorem ipsum dolor", sender: .user(id: "0")))
                .previewLayout(.sizeThatFits)
            NewMessageView(newMessage: .constant(""), sendAction: { print("📨 Sending") })
                .previewLayout(.sizeThatFits)
            NavigationView {
                ChatView(
                    viewModel: ChatViewModel(
                        user: User(name: "Test")))
            }
        }
    }
}

