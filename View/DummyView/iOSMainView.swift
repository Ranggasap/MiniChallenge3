//
//  iOSMainView.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import SwiftUI
import Combine
import WatchConnectivity

struct iOSMainView: View {
    @StateObject var iOSVM = iOSManager()

    var body: some View {
        NavigationStack {
            VStack {
//                HStack {
//                    Button(action: {
//                        connectivity.toggleRecordState()
//                        print("\(connectivity.isRecording)")
//                    }, label: {
//                        Text(connectivity.isRecording ? "Stop Recording" : "Start Recording")
//                    })
//                    .padding()
//                }
                
                HStack {
                    Button(action: {
                        iOSVM.isDirected = true
                    }, label: {
                        Text("Navigate to LocationView")
                    })
                    .padding()
                }
                
                if iOSVM.isLoading {
                    ProgressView("Loading recordings...") // Show a loading indicator
                        .onAppear {
                            iOSVM.audio.recordings = iOSVM.fetchRecordings()
                            iOSVM.isLoading = false // Hide the loading indicator
                        }
                } else {
                    List(iOSVM.audio.recordings.sorted(by: { $0.lastPathComponent > $1.lastPathComponent }), id: \.self) { recording in
                        HStack {
                            Text(recording.lastPathComponent)
                            Spacer()
                            Button("Play") {
                                iOSVM.playRecording(recording)
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $iOSVM.isDirected) {
                iOSLocationView()
            }
            .onReceive(iOSVM.connectivity.$isReceived) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if newValue {
                        iOSVM.audio.recordings = iOSVM.fetchRecordings()
                        iOSVM.connectivity.isReceived = false
                        iOSVM.isLoading = true
                    }
                }
            }
        }
    }
}


#Preview {
    iOSMainView()
}
