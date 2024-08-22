//
//  WatchView.swift
//  Mini3 Watch App
//
//  Created by Vincent Saranang on 21/08/24.
//

import SwiftUI

struct WatchView: View {
    @State var alreadyPin = false
    @State var isAutoRecord: Bool = false
    
    @StateObject var watchVM = WatchManager()
    
    var body: some View {
        ZStack{
            if !watchVM.isRecording{
                Color(.colorBackground1)
                    .ignoresSafeArea()
                Image(.watchPattern1)
                    .resizable()
                    .scaledToFit()
                    .scaledToFill()
            } else{
                Color(.colorBackground2)
                    .ignoresSafeArea()
                PulseWatchView()
            }
            
            Image(.avatarWatch1)
                .resizable()
                .scaledToFit()
                .scaledToFill()
                .clipped()
                .frame(width: WKInterfaceDevice.current().screenBounds.size.width, height: WKInterfaceDevice.current().screenBounds.size.height)
            
            VStack {
                Spacer()
                Button(action: {
                    if watchVM.isRecording{
                        alreadyPin = true
                    } else {
                        withAnimation{
                            watchVM.toggleRecordingState(watchVM.connectivity, watchVM.isRecording)
                        }
                    }
                }) {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: WKInterfaceDevice.current().screenBounds.size.width-24, height: 50)
                        .foregroundColor(.buttonColor1)
                        .overlay{
                            Text(watchVM.isRecording ? "Add Pin Point" : "Start Record")
                        }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 24)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            
            VStack {
                HStack {
                    if watchVM.isRecording{
                        Button(action: {
                            watchVM.toggleRecordingState(watchVM.connectivity, watchVM.isRecording)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .foregroundColor(.black.opacity(0.8))
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                    Button(action: {
                        isAutoRecord.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .stroke(.buttonColor4, lineWidth: 8)
                                .fill(isAutoRecord ? .buttonColor4 : .buttonColor5)
                                .frame(width: 24, height: 24)
                                .overlay{
                                    if isAutoRecord{
                                        Image(systemName: "record.circle")
                                            .resizable()
                                            .foregroundColor(.buttonColor2)
                                    }
                                }
                            
                        }
                        
                            
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(width: WKInterfaceDevice.current().screenBounds.size.width-24)
                Spacer()
            }
            .frame(height: WKInterfaceDevice.current().screenBounds.size.height-24)
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

#Preview {
    WatchView(watchVM: WatchManager())
}
