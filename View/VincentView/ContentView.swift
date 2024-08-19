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
    @State private var isAutoRecording = false
    @State private var isRecord = false
    @State private var endRecord = true
    
    var body: some View {
        NavigationView{
            ZStack {
                if endRecord{
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
                        if !isRecord{
                            ToggleRecordView(isAutoRecording: $isAutoRecording)
                        }
                        if isRecord && endRecord{
                            HStack(spacing:20){
                                NavigationLink(destination:ValidationPageView()){
                                    RoundedRectangle(cornerRadius: 14)
                                        .foregroundColor(.buttonColor3)
                                        .frame(height: 55)
                                        .overlay{
                                            Text("Yes")
                                                .foregroundColor(.fontColor1)
                                                .font(.lt(size: 20, weight: .bold))
                                        }
                                }
                                Button(action: {
                                    isRecord = false
                                    endRecord = true
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
                                isRecord = true
                                endRecord.toggle()
                            }) {
                            RoundedRectangle(cornerRadius: 14)
                                .foregroundColor(isRecord ? .buttonColor2 : .buttonColor1)
                                .frame(width: UIScreen.main.bounds.width-64, height: 62)
                                .overlay{
                                    Text(isRecord ? "End Record" : "Start Record")
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
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}

