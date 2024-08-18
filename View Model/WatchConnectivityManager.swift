//
//  sendFileManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import WatchConnectivity

enum stringSent: String {
    case recording = "recording"
    case recordState = "recordState"
}

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isReceived = false
    @Published var isRecording = false
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session =  WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
#if os(iOS)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        // iOS specific implementation
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // iOS specific implementation
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // iOS specific implementation
    }
#else
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        // Provide some implementation or comment on watchOS specifics if necessary
    }
    
    func sendRecordingToiPhone(_ recordings: [URL], _ currentFileName: URL) {
        guard let recordingURL = recordings.first(where: { $0.lastPathComponent == currentFileName.lastPathComponent }),
              FileManager.default.fileExists(atPath: recordingURL.path) else {
            print("File does not exist at path: \(currentFileName.path)")
            return
        }
        
        sendFile(recordingURL, stringSent.recording.rawValue)
    }
#endif
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        guard let key = file.metadata?.keys.first, let stringSent = stringSent(rawValue: key) else {
            print("Unknown or missing metadata key.")
            return
        }
        
        switch stringSent {
            case .recording:
                if let fileName = file.metadata?[stringSent.rawValue] as? String {
                    let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
                    print("Saving file to: \(destinationURL.path)")
                    
                    do {
                        try FileManager.default.moveItem(at: file.fileURL, to: destinationURL)
                        print("File moved successfully to: \(destinationURL.path)")
                        DispatchQueue.main.async {
                            self.isReceived.toggle()
                        }
                    } catch {
                        print("Failed to save file: \(error.localizedDescription)")
                    }
                }
            case .recordState:
                DispatchQueue.main.async {
                    self.isRecording.toggle()
                }
        }
    }
    
    func sendRecordingState(_ url: URL) {
        sendFile(url, stringSent.recordState.rawValue)
    }
    
    func sendFile(_ url: URL, _ fileName: String) {
        let session = WCSession.default
        if session.activationState == .activated {
            // Pass the correct file name in the metadata
            let metadata = [fileName: url.lastPathComponent]
            let fileTransfer = session.transferFile(url, metadata: metadata)
            print("File transfer initiated for: \(url.lastPathComponent)")

            // Monitor the progress of the file transfer
            fileTransfer.progress.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
        } else {
            print("Session is not activated")
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "fractionCompleted", let progress = object as? Progress {
            print("Transfer progress: \(progress.fractionCompleted * 100)%")
            
            if progress.fractionCompleted == 1.0 {
                // Transfer is complete
                print("File transfer completed successfully.")
                
                // Remove observer to prevent memory leaks
                progress.removeObserver(self, forKeyPath: "fractionCompleted")
            }
        }
    }
    
}
