//
//  RecordingWatchUI.swift
//  Mini3 Watch App
//
//  Created by Rangga Saputra on 20/08/24.
//

import SwiftUI

struct RecordingWatchUI: View {
    var body: some View {
        ZStack(alignment: .top){
            Color("ColorBackground2")
                .ignoresSafeArea()
            
            ZStack(alignment: .center){
                Image(uiImage: UIImage(named: "DonutBitedWatchLight")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                
                Image(uiImage: UIImage(named: "DonutBitedWatchLight")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 175)
                
                Image(uiImage: UIImage(named: "DonutBitedWatchLight")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 145)
                
              
            }
            .offset(x:0, y: -9)
            .ignoresSafeArea()
            
            
            VStack{
                
                HStack{
                    
                }
                
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
    RecordingWatchUI()
}
