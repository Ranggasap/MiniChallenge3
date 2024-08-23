//
//  PulseWatchView.swift
//  Mini3 Watch App
//
//  Created by Vincent Saranang on 21/08/24.
//

import SwiftUI

struct PulseWatchView: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var scaleChanges: CGFloat = 1.5
    @State private var opacityChanges: Double = 1.0
    
    private let screenWidth = WKInterfaceDevice.current().screenBounds.size.width
    
    var body: some View {
        VStack {
            ZStack {
                Image(.pulseIcon)
                    .resizable()
                    .frame(width: screenWidth / 2, height: screenWidth / 2)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: scale)
                    .onAppear {
                        scale = scaleChanges
                        opacity = opacityChanges
                    }
                
                Image(.pulseIcon)
                    .resizable()
                    .frame(width: screenWidth / 2 + screenWidth / 4.4, height: screenWidth / 2 + screenWidth / 4.4)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: scale)
                    .onAppear {
                        scale = scaleChanges
                        opacity = opacityChanges
                    }
                
                Image(.pulseIcon)
                    .resizable()
                    .frame(width: screenWidth / 2 + screenWidth / 2.2, height: screenWidth / 2 + screenWidth / 2.2)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: scale)
                    .onAppear {
                        scale = scaleChanges
                        opacity = opacityChanges
                    }
                
                Image(.pulseIcon)
                    .resizable()
                    .frame(width: screenWidth / 2 + screenWidth / 1.1, height: screenWidth / 2 + screenWidth / 1.1)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: scale)
                    .onAppear {
                        scale = scaleChanges
                        opacity = opacityChanges
                    }
                
//                Image(.pulseIcon)
//                    .resizable()
//                    .frame(width: screenWidth / 2 + screenWidth / 0.55, height: screenWidth / 2 + screenWidth / 0.55)
//                    .scaleEffect(scale)
//                    .opacity(opacity)
//                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: scale)
//                    .onAppear {
//                        scale = scaleChanges
//                        opacity = opacityChanges
//                    }
//
//                Image(.pulseIcon)
//                    .resizable()
//                    .frame(width: screenWidth / 2 + screenWidth / 0.275, height: screenWidth / 2 + screenWidth / 0.275)
//                    .scaleEffect(scale)
//                    .opacity(opacity)
//                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: scale)
//                    .onAppear {
//                        scale = scaleChanges
//                        opacity = opacityChanges
//                    }
            }
        }
        .clipped()
        .frame(width: screenWidth, height: WKInterfaceDevice.current().screenBounds.size.height)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    PulseWatchView()
}
