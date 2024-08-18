//
//  iOSManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import Foundation

class iOSManager: recordFunction, ObservableObject {
    @Published var audio = Audio()
    @Published var isLoading = true
    @Published var isDirected = false
    @Published var connectivity = WatchConnectivityManager()
    
    func toggleRecordingState() {
        let fm = FileManager.default
        let sourceURL = URL.documentsDirectory.appending(path: "saved_file")
        if !fm.fileExists(atPath: sourceURL.path) {
            try? "toggle recording state".write(to: sourceURL, atomically: true, encoding: .utf8)
        }
        connectivity.sendRecordingState(sourceURL)
    }
}
