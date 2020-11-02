//
//  ContentView.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

import SwiftUI

struct Chat: Decodable {
    let id: String
}

struct ChatView: View {
    @EnvironmentObject private var user: User
    @State private var newMessage: String = ""
    @State private var messages: [String] = ["Hello"]

    var body: some View {
            VStack(spacing: 16) {
                ScrollView {
                    ForEach(messages, id: \.self) { message in
                        HStack {
                            Spacer()
                            Text(message)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                }
                HStack {
                    TextField("Введите сообщение", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button { send(message: newMessage) } label: { Image(systemName: "paperplane.fill") }
                }
            }
            .navigationBarTitle(user.name)
            .padding()
    }

    private func send(message: String) {
        // network.sendMessage(message)private
        messages.append(message)
    }
}

struct ContentView_Previews: PreviewProvider {
    private static let user = User()
    static var previews: some View {
        NavigationView {
            ChatView().environmentObject(user)
                .onAppear { user.name = "Test" }
        }
    }
}

