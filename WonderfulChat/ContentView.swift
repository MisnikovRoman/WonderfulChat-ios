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

let userId = UUID().uuidString

struct ChatView: View {
    enum ViewState {
        case loading
        case failure(String)
        case success(String)
    }

    private let network = Network()

    @State var newMessage: String = ""
    @State var messages: [String] = ["Hello"]

    var body: some View {
        NavigationView {
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
            .navigationBarTitle(userId)
            .onAppear {
                openSocket()
                setReceiveMessageHandler()
            }
            .padding()
        }
    }

    private func openSocket() {
        guard let url = URL(string: Api.websocketUrl) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(userId, forHTTPHeaderField: "id")
        
        network.connectWebSocket(request: request)
    }

    private func send(message: String) {
        network.sendMessage(message)
        messages.append(message)
    }

    private func setReceiveMessageHandler() {
        network.onReceiveMessage { message in
            messages.append(message)
            setReceiveMessageHandler()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

