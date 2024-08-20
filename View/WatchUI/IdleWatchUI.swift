//
//  IdleWatchUI.swift
//  Mini3 Watch App
//
//  Created by Rangga Saputra on 20/08/24.
//

import SwiftUI

struct IdleWatchUI: View {
    var body: some View {
        ZStack(alignment: .top){
            Color("ColorBackground1")
                .ignoresSafeArea()
            Image(uiImage: UIImage(named: "DonutBitedWatchDark")!)
                .offset(x: -75, y: 75)
            Image(uiImage: UIImage(named: "DeerHornWatchDark")!)
                .resizable()
                .scaledToFit()
                .offset(x: 70, y:-30)

                .frame(width: 100)
            
            
            
            
            VStack{
                
                Image(uiImage: UIImage(named: "DandenionWatchLight")!)
                    .resizable()
                    .scaledToFit()
                
                Button(action: {
                    
                }) {
                    Text("Start Record")
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(Color("ButtonColor1"))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 200, height: 10)))
            }
            .frame(maxWidth: .infinity)
            .background(Color.clear)
        }
        
    }
}

#Preview {
    IdleWatchUI()
}

