//
//  BubbleChatView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 19/08/24.
//

import SwiftUI

struct BubbleChatView: View {
    var text: String
    var body: some View {
        VStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height*5/8 : (UIScreen.main.bounds.height<800 ? UIScreen.main.bounds.height*7/12 : UIScreen.main.bounds.height*4.5/8))
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(width: UIScreen.main.bounds.width-64, alignment: .bottom)
                .background(.containerColor2)
                .cornerRadius(10)
            Spacer()
        }
    }
}

