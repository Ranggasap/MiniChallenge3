//
//  bgStyle.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

struct bgStyle: View {
    @Binding var pattern: String
    @Binding var colorBg: String
    
    var body: some View {
        VStack {
            Image(pattern)
                .resizable()
                .scaledToFit()
                .scaledToFill()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .background(Color(colorBg))
    }
}
