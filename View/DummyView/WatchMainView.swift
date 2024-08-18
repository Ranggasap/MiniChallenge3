//
//  WatchMainView.swift
//  Mini3 Watch App
//
//  Created by Bryan Vernanda on 18/08/24.
//

import SwiftUI
import Combine
import WatchConnectivity

struct WatchMainView: View {
    @StateObject var watchVM = WatchManager()

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    watchVM.toggleRecordingState(watchVM.connectivity, watchVM.isRecording)
                }, label: {
                    Text(watchVM.isRecording ? "Stop Recording" : "Start Recording")
                })
                .padding()
            }
            
            if watchVM.isLoading {
                ProgressView("Loading recordings...") // Show a loading indicator
                    .onAppear {
                        watchVM.audio.recordings = watchVM.fetchRecordings()
                        watchVM.isLoading = false // Hide the loading indicator
                    }
            } else {
                List(watchVM.audio.recordings.sorted(by: { $0.lastPathComponent > $1.lastPathComponent }), id: \.self) { recording in
                    HStack {
                        Text(recording.lastPathComponent)
                        Spacer()
                        Button("Play") {
                            watchVM.playRecording(recording)
                        }
                    }
                }
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
    }
}


#Preview {
    WatchMainView()
}
