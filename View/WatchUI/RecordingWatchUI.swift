//
//  RecordingWatchUI.swift
//  Mini3 Watch App
//
//  Created by Rangga Saputra on 20/08/24.
//

import SwiftUI

struct RecordingWatchUI: View {
    
    @Binding var isRecording: Bool
    
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
                Image(uiImage: UIImage(named: "DandenionWatchLight")!)
                    .resizable()
                    .scaledToFit()
                
                Button(action: {
                    withAnimation{
                        isRecording = false
                    }
                }) {
                    Text("Add Pin Point")
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(Color("ButtonColor1"))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 200, height: 10)))
            }
            .background(Color.clear)
        }
    }
}

struct AutoRecordIndicatorOn: View {
    
    @Binding var isAutoRecord: Bool
    
    var body: some View {
        ZStack{
            Circle()
            Circle()
                .foregroundColor(Color("ColorBackground2"))
                .padding(6)
            Circle()
                .padding(8)
            Circle()
                .foregroundColor(Color("ColorBackground2"))
                .padding(12)
        }
        .onTapGesture {
            withAnimation{
                isAutoRecord = false
            }
        }
    }
}


#Preview {
    @State var isRecording = false
    return RecordingWatchUI(isRecording: $isRecording)
}


