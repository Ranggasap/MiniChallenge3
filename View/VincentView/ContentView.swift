//
//  ContentView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

struct ContentView: View {
    // pake state ini buat masing" view, atau bagusnya kalau dibikin observableobject bikin pattern1, pattern2 buat call masing" pattern dan colorbackgroundnya (1,2,3,dst) (semua yang disini pindahin ke observableobject, jdi cuman perlu call 1 state disini
    @State private var username = "Natalie"
    @State private var navigateToValidation = false
    @StateObject var iOSVM = iOSManager()
    
    var body: some View {
        NavigationStack{
            ZStack {
                if iOSVM.endRecord{
                    bgStyle(pattern: "ItemBackground1", colorBg: "ColorBackground1")
                    AvatarView(avatar: "avatar1")
                }else{
                    bgStyle(pattern: "ItemBackground2", colorBg: "ColorBackground2")
                    AvatarView(avatar: "avatar2")
                }
                
                BubbleChatView(text: "How was your day? Keep your head high, knowing that you have the power within you to face any challenge.")
                
                HelloView(username: $username)
                
                VStack{
                    Spacer()
                    VStack(spacing:16){
                        if !iOSVM.isRecording{
                            ToggleRecordView(isAutoRecording: $iOSVM.isAutoRecording)
                        }
                        if iOSVM.isRecording && iOSVM.endRecord{
                            HStack(spacing:20){
                                RoundedRectangle(cornerRadius: 14)
                                    .foregroundColor(.buttonColor3)
                                    .frame(height: 55)
                                    .overlay {
                                        Text("Yes")
                                            .foregroundColor(.fontColor1)
                                            .font(.lt(size: 20, weight: .bold))
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        iOSVM.toggleStoredState(iOSVM.connectivity, true)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            iOSVM.isRecording = false
                                            navigateToValidation = true
                                        }
                                    })
                                Button(action: {
                                    iOSVM.toggleStoredState(iOSVM.connectivity, false)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        iOSVM.isRecording = false
                                    }
                                }) {
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(.buttonColor3, lineWidth: 2)
                                        .frame(height: 55)
                                        .overlay{
                                            Text("No")
                                                .foregroundColor(.fontColor3)
                                                .font(.lt(size: 20, weight: .bold))
                                        }
                                }
                            }
                            .padding(.horizontal, 32)
                        }else{
                            Button(action: {
                                if (iOSVM.isRecording != true) || (iOSVM.isRecording && !iOSVM.endRecord){
                                    iOSVM.toggleRecordingState(iOSVM.connectivity, iOSVM.isRecording)
                                } else {
                                    iOSVM.endRecord.toggle()
                                }
                            }) {
                            RoundedRectangle(cornerRadius: 14)
                                .foregroundColor(iOSVM.isRecording ? .buttonColor2 : .buttonColor1)
                                .frame(width: UIScreen.main.bounds.width-64, height: 62)
                                .overlay{
                                    Text(iOSVM.isRecording ? "End Record" : "Start Record")
                                        .font(.lt(size: 20, weight: .bold))
                                        .foregroundColor(.fontColor1)
                                }
                                .padding(.horizontal, 32)
                            }
                        }
                    }
                    .padding(.top, 28)
                    .padding(.bottom, DynamicIslandChecker.getBotPadding())
                    .background(.containerColor1)
                    .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
                }
                
                
            }
            .navigationDestination(isPresented: $navigateToValidation) {
                ValidationPageView(navigateToValidation: $navigateToValidation)
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}

