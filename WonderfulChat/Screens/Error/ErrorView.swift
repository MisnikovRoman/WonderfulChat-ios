//
//  ErrorView.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 15.11.2020.
//

import SwiftUI

struct ErrorView: View {
    enum Constant {
        static let image = "wifi.exclamationmark"
        static let title: String = "Что-то пошло не так..."
        static let errorDescription: String = "Длинное описание почему что-то могло пойти не так"
        static let retryButtonTitle: String = "Повторить"
    }
    
    @ObservedObject var viewModel: ErrorViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: Constant.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(Constant.title).font(.title2).bold()
            Text(Constant.errorDescription).foregroundColor(.gray)
            
            // optional button
            if let retryAction = viewModel.retry {
                Button(Constant.retryButtonTitle, action: retryAction)
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }.multilineTextAlignment(.center)
        
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(viewModel: ErrorViewModel {})
    }
}
