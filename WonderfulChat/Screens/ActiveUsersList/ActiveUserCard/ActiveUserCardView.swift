//
//  ActiveUserCardView.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 28.11.2020.
//

import SwiftUI

class ActiveUserViewModel: ObservableObject, Identifiable {

    let id: String
    let name: String
    @Published var unreadMessagesCount = 0
    
    init(id: String, name: String, unreadMessagesCount: Int = 0) {
        self.id = id
        self.name = name
        self.unreadMessagesCount = unreadMessagesCount
    }
}

struct ActiveUserCardView: View {
    
    @ObservedObject var viewModel: ActiveUserViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Text(Emoji.container.randomElement() ?? "")
                .font(.largeTitle)
            Text(viewModel.name)
                .font(.title3)
            Spacer()
            if viewModel.unreadMessagesCount != 0 {
                ZStack {
                    Circle()
                        .fill(Color(.systemBlue))
                        .frame(width: 20, height: 20)
                    Text("\(viewModel.unreadMessagesCount)")
                        .foregroundColor(Color.white)
                        .font(.caption2)
                }
            }
        }
    }
}

struct ActiveUserCardView_Previews: PreviewProvider {
    static var vm = ActiveUserViewModel(id: "", name: "Константин Константинопольский", unreadMessagesCount: 2)
    static let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    static var previews: some View {
        Group {
            ActiveUserCardView(viewModel: vm)
            ActiveUserCardView(viewModel: vm)
                .environment(\.colorScheme, .dark)
        }
        .previewLayout(.sizeThatFits)
        .onReceive(timer) { _ in
            vm.unreadMessagesCount += 1
        }
    }
}
