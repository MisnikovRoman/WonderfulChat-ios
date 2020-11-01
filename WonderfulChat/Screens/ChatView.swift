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
    enum ViewState {
        case loading
        case failure(String)
        case success(String)
    }

    private let network = Network()

    @EnvironmentObject var user: User
    @State var newMessage: String = ""
    @State var messages: [String] = ["Hello"]

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
            .onAppear {
                openSocket()
            }
            .padding()
    }

    private func openSocket() {
        guard let url = URL(string: Api.heroku) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(user.id.uuidString, forHTTPHeaderField: "id")
        
        network.connectWebSocket(request: request)
    }

    private func send(message: String) {
        network.sendMessage(message)
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
