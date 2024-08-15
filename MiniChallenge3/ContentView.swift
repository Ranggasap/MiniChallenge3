//
//  ContentView.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 29/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color("BackgroundColorPurple")
                .ignoresSafeArea()
            MainViewControllerRepresentable()
        }
    }
}

#Preview {
    ContentView()
}
