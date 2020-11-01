//
//  IntroduceView.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import SwiftUI

struct IntroduceView: View {
    
    @EnvironmentObject var user: User
    @State var userNameInput: String = ""
    
    var body: some View {
        ZStack {
            TextField("name", text: $user.name)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
            VStack {
                Spacer()
                NavigationLink("Next", destination: ActiveUsersList())
                    .padding()
            }
        }
        .navigationBarTitle("Introduce yourself")
    }
}

struct IntroduceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IntroduceView()
                .environmentObject(User())
        }
    }
}
