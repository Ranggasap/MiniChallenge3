//
//  UpdateLocationView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 21/08/24.
//

import SwiftUI

struct UpdateLocationView: View {
    @State var alreadyRecord = false
    @StateObject var iOSVM = iOSManager()
    @StateObject private var listViewModel = EvidenceListViewModel()
    
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                if iOSVM.endRecord {
                    bgStyle(pattern: "ItemBackground1", colorBg: "ColorBackground1")
                    AvatarView(avatar: "avatar1")
                    BubbleChatView(text: "How was your day? Keep your head high, knowing that you have the power within you to face any challenge.")
                } else {
                    bgStyle(pattern: "ItemBackground2", colorBg: "ColorBackground2")
                    PulseView()
                    AvatarView(avatar: "avatar2")
                    BubbleChatView(text: "Right now, I company you and observe your surrounding on your apple watch")
                }
                
                VStack {
                    Spacer()
                    VStack(spacing: 16) {
                        if iOSVM.isRecording && iOSVM.endRecord {
                        } else {
                            Button(action: {
                                if iOSVM.isRecording {
                                    iOSVM.toggleRecordingState(iOSVM.connectivity, iOSVM.isRecording)
                                    showingAlert = true
                                } else {
                                    iOSVM.toggleRecordingState(iOSVM.connectivity, iOSVM.isRecording)
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 14)
                                    .foregroundColor(iOSVM.isRecording ? .buttonColor2 : .buttonColor1)
                                    .frame(width: UIScreen.main.bounds.width - 64, height: 62)
                                    .overlay {
                                        Text(iOSVM.isRecording ? "End Record" : "Start Record")
                                            .font(.lt(size: 20, weight: .bold))
                                            .foregroundColor(.fontColor1)
                                    }
                                    .padding(.horizontal, 32)
                            }
                            
                            if alreadyRecord {
                                Button(action: {
                                    
                                }) {
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.buttonColor3)
                                        .frame(width: UIScreen.main.bounds.width - 64, height: 62)
                                        .overlay {
                                            Text("Report")
                                                .font(.lt(size: 20, weight: .bold))
                                                .foregroundColor(.fontColor3)
                                        }
                                        .padding(.horizontal, 32)
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    listViewModel.navigateToValidation = true
                                })
                            }
                        }
                    }
                    .padding(.top, 28)
                    .padding(.bottom, DynamicIslandChecker.getBotPadding())
                    .background(.containerColor1)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
            }
            .navigationDestination(isPresented: $listViewModel.navigateToPinValidation) {
                ValidationPageView(navigateToValidation: $listViewModel.navigateToPinValidation, onPinValidation: true, alreadyRecord: $alreadyRecord, currentCase: 2)
            }
            .navigationDestination(isPresented: $listViewModel.navigateToValidation) {
                ValidationPageView(navigateToValidation: $listViewModel.navigateToValidation, onPinValidation: false, alreadyRecord: $alreadyRecord, currentCase: 1)
            }
            .alert(isPresented: $showingAlert) { // Present the alert
                Alert(
                    title: Text("Did you feel uncomfortable?"),
                    message: Text("Share to us if you got catcalled while walking just now"),
                    primaryButton: .default(Text("Yes")) {
                        iOSVM.isRecording = false
                        listViewModel.navigateToPinValidation = true
                    },
                    secondaryButton: .cancel(Text("No")) {
                        iOSVM.isRecording = false
                    }
                )
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView(alreadyRecord: false, iOSVM: iOSManager())
}

