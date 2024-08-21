//
//  HelloView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

struct HelloView: View {
    @Binding var username: String

    var body: some View {
        VStack{
            HStack{
                Text("Hi, \(username)!")
                    .font(.lt(size: 32, weight: .bold))
                    .foregroundColor(.fontColor1)
                Spacer()
                Image(.notificationIcon)
            }
            .frame(width: UIScreen.main.bounds.width-32)
            
            Spacer()
        }
        .padding(.top, DynamicIslandChecker.getTopPadding())
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HelloView(username: .constant("Vincent"))
}
