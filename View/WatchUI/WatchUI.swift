//
//  WatchUI.swift
//  Mini3 Watch App
//
//  Created by Rangga Saputra on 20/08/24.
//

import SwiftUI

struct WatchUI: View {
    @State var isAutoRecord: Bool = false
    
    @StateObject var watchVM = WatchManager()
    
    var body: some View {
        ZStack(alignment: .top){
            
            if watchVM.isRecording {
                RecordingWatchUI(watchVM: watchVM)
                    .transition(.opacity)
                HStack{
                    StopRecordingBackButton(watchVM: watchVM)
                        .frame(width: 30)
                    
                    Spacer()
                        .frame(width: 125)
                }
                .padding()
                .padding(.top, 20)
                .ignoresSafeArea()
            } else {
                IdleWatchUI(watchVM: watchVM)
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
        .onAppear {
            watchVM.requestRecordPermission()
        }
        .onChange(of: watchVM.isRecording) { _, newValue in
            if newValue {
                watchVM.startRecording()
            } else {
                watchVM.stopRecording()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: watchVM.isRecording)
    }
    
}

struct StopRecordingBackButton: View {
    
    @ObservedObject var watchVM: WatchManager
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.black)
                .opacity(0.7)
            Image(systemName: "xmark")
        }
        .onTapGesture {
            watchVM.toggleRecordingState(watchVM.connectivity, watchVM.isRecording)
        }
    }
}


#Preview {
    WatchUI()
}
