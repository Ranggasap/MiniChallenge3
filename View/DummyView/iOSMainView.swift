//
//  iOSMainView.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import SwiftUI

struct iOSMainView: View {
    @StateObject private var iOSVM = iOSManager()
    @StateObject var connectivity = WatchConnectivityManager()

    var body: some View {
        VStack {
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
        .onChange(of: connectivity.isReceived) { _, newValue in
            if newValue == true {
                iOSVM.audio.recordings = iOSVM.fetchRecordings()
                connectivity.isReceived.toggle()
            }
        }
    }
}


#Preview {
    iOSMainView()
}
