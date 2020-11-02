//
//  IntroduceView.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import SwiftUI

struct IntroduceView: View {
    
    private let user: User
    
    @EnvironmentObject
    private var factory: ViewFactory
    @State
    private var userNameInput: String = ""
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        ZStack {
            TextField("name", text: $userNameInput)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
            VStack {
                Spacer()
                NavigationLink("Next", destination: factory.activeUsersListView())
                    .padding()
            }
        }
        .navigationBarTitle("Introduce yourself")
        .onChange(of: userNameInput) { user.name = $0 }
    }
}

struct IntroduceView_Previews: PreviewProvider {
    static let mockUser = User()
    
    static var previews: some View {
        NavigationView {
            IntroduceView(user: mockUser).environmentObject(ViewFactory())
        }
    }
}
