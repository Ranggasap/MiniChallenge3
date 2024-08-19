//
//  AvatarView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 19/08/24.
//

import SwiftUI

struct AvatarView: View {
    var avatar: String
    var body: some View {
        VStack{
            Image(avatar)
                .resizable()
                .scaledToFit()
                .scaledToFill()
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

