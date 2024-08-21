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
    @State private var scaleChanges: CGFloat = 1.5
    @State private var opacityChanges: Double = 1.0
    
    var body: some View {
        VStack{
            ZStack {
                Image(.pulseIcon)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                    .onAppear {
                        scale = scaleChanges
                        opacity = opacityChanges
                    }
                Image(.pulseIcon)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width/2+UIScreen.main.bounds.width/4.4, height: UIScreen.main.bounds.width/2+UIScreen.main.bounds.width/4.4)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                    .onAppear {
                        scale = scaleChanges
                        opacity = opacityChanges
                    }
                Image(.pulseIcon)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width/2+UIScreen.main.bounds.width/2.2, height: UIScreen.main.bounds.width/2+UIScreen.main.bounds.width/2.2)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                    .onAppear {
                        scale = scaleChanges
                        opacity = opacityChanges
                    }
                Image(.pulseIcon)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width/2+UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width/2+UIScreen.main.bounds.width/1.1)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                    .onAppear {
                        scale = scaleChanges
                        opacity = opacityChanges
                    }
            }
            .padding(.bottom, UIScreen.main.bounds.width/4)
//            .background(.colorBackground2)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    PulseView()
}
