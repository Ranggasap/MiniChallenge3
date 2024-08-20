//
//  PulseView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 19/08/24.
//

import SwiftUI

struct PulseView: View {
    // mo w update lg nanti (blom kelar)
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Image(.pulseIcon)
                .resizable()
                .frame(width: 320, height: 320)
                .scaleEffect(scale)
                .opacity(opacity)
                .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                .onAppear {
                    scale = 1.5
                    opacity = 0.0
                }
            Image(.pulseIcon)
                .resizable()
                .frame(width: 400, height: 400)
                .scaleEffect(scale)
                .opacity(opacity)
                .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                .onAppear {
                    scale = 1.5
                    opacity = 0.0
                }
            Image(.pulseIcon)
                .resizable()
                .frame(width: 480, height: 480)
                .scaleEffect(scale)
                .opacity(opacity)
                .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                .onAppear {
                    scale = 1.5
                    opacity = 0.0
                }
            
            
            Image(.pulseIcon)
                .resizable()
                .frame(width: 260, height: 260)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.colorBackground1)
        
    }
}

#Preview {
    PulseView()
}
