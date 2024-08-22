//
//  ContentView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @State private var username = "Natalie"

    
    let container = CKContainer(identifier: "iCloud.com.dandenion.MiniChallenge3")

    @State var alreadyRecord = false
    @StateObject var iOSVM = iOSManager()
    @StateObject private var listViewModel = EvidenceListViewModel()

    
    // test state
//    @State var isRecord = false
//    @State var isAutoRecording = false
//    @State var isEndRecord = true
    
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                //testview
                if !iOSVM.isRecording {
                    bgStyle(pattern: "ItemBackground1", colorBg: "ColorBackground1")
                    AvatarView(avatar: "avatar1")
                    BubbleChatView(text: "How was your day? Keep your head high, knowing that you have the power within you to face any challenge.")

                } else {

                    bgStyle(pattern: "ItemBackground2", colorBg: "ColorBackground2")
                    PulseView()
                    AvatarView(avatar: "avatar2")
                    BubbleChatView(text: "Right now, I company you and observe your surrounding on your apple watch")
                }

                HelloView(username: $username)
                VStack {
                    Spacer()
                    VStack(spacing: 16) {
                        if !iOSVM.isRecording{
                            ToggleRecordView(isAutoRecording: $iOSVM.isAutoRecording)
                        }

                        Button(action: { //isrecord = true, endrecord = false
                            if (iOSVM.isRecording != true) || (iOSVM.isRecording && !iOSVM.endRecord){
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
                                // report action
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

                        }
                    }
                    .padding(.top, 28)
                    .padding(.bottom, DynamicIslandChecker.getBotPadding())
                    .background(.containerColor1)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                
            }
            
            .onAppear {
                print("\(iOSVM.isRecording), \(iOSVM.endRecord)")
            }
            
            .onChange(of: iOSVM.endRecord) {
                if iOSVM.endRecord && iOSVM.isRecording {
                    showingAlert = true
                }
            }
            
            .onReceive(iOSVM.connectivity.$isReceived) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if newValue {
                        iOSVM.audio.recordings = iOSVM.fetchRecordings()
                        iOSVM.connectivity.isReceived = false
                    }
                }
            }

            // ini flow lama yg no progress bar and back
            .navigationDestination(isPresented: $listViewModel.navigateToPinValidation) {
                ValidationPageView(navigateToValidation: $listViewModel.navigateToPinValidation, onPinValidation: true, reportVm: ReportManager(container: container), alreadyRecord: $alreadyRecord, iOSVM: iOSVM, listViewModel: listViewModel)
            }
            //
            .navigationDestination(isPresented: $listViewModel.navigateToValidation) {
                ValidationPageView(navigateToValidation: $listViewModel.navigateToValidation, onPinValidation: false, reportVm: ReportManager(container: container), alreadyRecord: $alreadyRecord, iOSVM: iOSVM, listViewModel: listViewModel)
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Did you feel uncomfortable?"),
                    message: Text("Share to us if you got catcalled while walking just now"),
                    primaryButton: .default(Text("Yes")) {
                        iOSVM.toggleStoredState(iOSVM.connectivity, true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            iOSVM.isRecording = false
                            listViewModel.navigateToValidation = true
                        }
                    },
                    secondaryButton: .cancel(Text("No")) {
                        iOSVM.toggleStoredState(iOSVM.connectivity, false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            iOSVM.isRecording = false
                        }
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

