//
//  LoadingView.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 22.11.2020.
//

import SwiftUI
import Combine

struct ModifiedCircle: View {
    let size: CGSize
    
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: size.width, height: size.height)
            .opacity(0.7)
    }
}

struct LoadingView: View {
    
    private let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
    
    // setting
    private let circleCount = 3
    private let circleSize = CGSize(width: 20, height: 20)
    private let absoluteOffset: CGFloat = 100
    private let animationDuration = 1.0
    private let delay = 0.2
    @State private var circleOffset: CGFloat = 0
     
    var body: some View {
        ZStack {
            ForEach((0..<circleCount), id:\.self) { index in
                ModifiedCircle(size: circleSize)
                    .offset(x: circleOffset)
                    .animation(Animation.easeInOut(duration: animationDuration)
                                .delay(delay * Double(index)))
            }
        }
        .frame(width: circleSize.width + absoluteOffset * 2, height: circleSize.height, alignment: .center)
        .onReceive(timer) { _ in circleOffset *= -1 }
        .onAppear { circleOffset = absoluteOffset }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
