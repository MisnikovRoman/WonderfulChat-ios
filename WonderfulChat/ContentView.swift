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

struct ContentView: View {
    enum ViewState {
        case loading
        case failure(String)
        case success(String)
    }

    private let network = Network()

    @State var viewState: ViewState = .loading

    var body: some View {
        VStack {
            switch viewState {
            case .loading: ProgressView()
            case .success(let id): Text("💬\nHere will be chat\n\(id)")
            case .failure(let description): Text("⚠️\nError: \(description)")
            }
        }
        .font(.title)
        .multilineTextAlignment(.center)
        .padding()
        .onAppear(perform: load)
    }

    private func load() {
        guard let url = URL(string: Api.baseUrl + Route.chat) else { return }
        network.get(from: url, Chat.self) { result in
            switch result {
            case .success(let chat): viewState = .success(chat.id)
            case .failure(let error): viewState = .failure(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
