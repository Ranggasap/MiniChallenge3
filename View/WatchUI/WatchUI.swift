//
//  WatchUI.swift
//  Mini3 Watch App
//
//  Created by Rangga Saputra on 20/08/24.
//

import SwiftUI

struct WatchUI: View {
    @State var isRecording: Bool = false
    @State var isAutoRecord: Bool = false
    
    var body: some View {
        ZStack(alignment: .top){
            
            if isRecording {
                RecordingWatchUI(isRecording: $isRecording)
                    .transition(.opacity)
                HStack{
                    
                    AutoRecordIndicatorOn(isAutoRecord: $isAutoRecord)
                        .frame(width: 30)
                    Spacer()
                        .frame(width: 125)
                }
                .padding()
                .padding(.top, 20)
                .ignoresSafeArea()
            } else {
                IdleWatchUI(isRecording: $isRecording)
                    .transition(.opacity)
                
            }
            
            if isAutoRecord {
                HStack{
                    Spacer()
                        .frame(width: 125)
                    AutoRecordIndicatorOn(isAutoRecord: $isAutoRecord)
                        .frame(width: 30)
                }
                .padding()
                .padding(.top, 20)
                .ignoresSafeArea()
                
            } else {
                HStack{
                    Spacer()
                        .frame(width: 125)
                    AutoRecordIndicatorOff(isAutoRecord: $isAutoRecord)
                        .frame(width: 30)
                }
                .padding()
                .padding(.top, 20)
                .ignoresSafeArea()
            }
            
        }
        .animation(.easeInOut(duration: 0.2), value: isRecording)
    }
}




#Preview {
    WatchUI()
}
