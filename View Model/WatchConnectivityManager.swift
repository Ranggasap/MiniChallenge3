//
//  WatchConnectivityManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isReceived = false
    
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

    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        // Extract the filename from the metadata
        let fileName = file.metadata?["fileName"] as? String ?? file.fileURL.lastPathComponent
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

        let session = WCSession.default
        if session.activationState == .activated {
            // Pass the correct file name in the metadata
            let metadata = ["fileName": recordingURL.lastPathComponent]
            let fileTransfer = session.transferFile(recordingURL, metadata: metadata)
            print("File transfer initiated for: \(recordingURL.lastPathComponent)")

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
    
#endif
    
}
