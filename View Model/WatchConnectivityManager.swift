//
//  sendFileManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import Combine
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isReceived = false
    var isRecordingSubject = CurrentValueSubject<Bool, Never>(false)
    var isRecording: Bool {
        get { isRecordingSubject.value }
        set { isRecordingSubject.send(newValue) }
    }
    var isStoredSubject = CurrentValueSubject<Bool, Never>(false)
    var isStored: Bool {
        get { isStoredSubject.value }
        set { isStoredSubject.send(newValue) }
    }
    var isAutoRecSubject = CurrentValueSubject<Bool, Never>(false)
    var isAutoRec: Bool {
        get { isAutoRecSubject.value }
        set { isAutoRecSubject.send(newValue) }
    }
    
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
    
    func sendStateChangeRequest(_ isRecording: Bool, _ storeRecord: String, _ isStored: Bool, _ isToggled: Bool) {
        let session = WCSession.default
        if session.activationState == .activated {
            if storeRecord == messageSent.stored.rawValue {
                session.sendMessage([messageSent.stored.rawValue: isStored], replyHandler: nil) { error in
                    print("Error sending request: \(error.localizedDescription)")
                }
            } else if storeRecord == messageSent.autoRec.rawValue {
                session.sendMessage([messageSent.autoRec.rawValue: isToggled], replyHandler: nil) { error in
                    print("Error sending request: \(error.localizedDescription)")
                }
            } else {
                session.sendMessage([messageSent.recordState.rawValue: isRecording], replyHandler: nil) { error in
                    print("Error sending request: \(error.localizedDescription)")
                }
            }
        } else {
            print("Session is not activated")
        }
    }
    
    // Handle messages from watchOS
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let request = message[messageSent.recordStateChangeRequest.rawValue] as? Bool {
            let tempIsRec = self.isRecording
            
            self.isRecording = request
            
            if tempIsRec == self.isRecording {
                session.sendMessage([messageSent.recordState.rawValue: self.isRecording], replyHandler: nil) { error in
                    print("Error sending message: \(error.localizedDescription)")
                }
            } else {
                session.sendMessage([messageSent.done.rawValue: self.isRecording], replyHandler: nil) { error in
                    print("Error sending message: \(error.localizedDescription)")
                }
            }
        } else if let request = message[messageSent.done.rawValue] as? Bool {
            self.isRecording = request
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
        
        sendFile(recordingURL, stringSent.recording.rawValue)
    }
    
    func sendRecordingStateChangeRequest(_ isRecording: Bool) {
        let session = WCSession.default
        if session.activationState == .activated {
            session.sendMessage([messageSent.recordStateChangeRequest.rawValue: isRecording], replyHandler: nil) { error in
                print("Error sending request: \(error.localizedDescription)")
            }
        } else {
            print("Session is not activated")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let request = message[messageSent.recordState.rawValue] as? Bool {
            let tempIsRec = self.isRecording
            
            self.isRecording = request
            
            if tempIsRec == self.isRecording {
                session.sendMessage([messageSent.recordStateChangeRequest.rawValue: self.isRecording], replyHandler: nil) { error in
                    print("Error sending message: \(error.localizedDescription)")
                }
            } else {
                session.sendMessage([messageSent.done.rawValue: self.isRecording], replyHandler: nil) { error in
                    print("Error sending message: \(error.localizedDescription)")
                }
            }
        } else if let request = message[messageSent.done.rawValue] as? Bool {
            self.isRecording = request
        } else if let request = message[messageSent.stored.rawValue] as? Bool {
            self.isStored = request
        } else if let request = message[messageSent.autoRec.rawValue] as? Bool {
            self.isAutoRec = request
        }
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
        }
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
//            print("Transfer progress: \(progress.fractionCompleted * 100)%")
            
            if progress.fractionCompleted == 1.0 {
                // Transfer is complete
                print("File transfer completed successfully.")
                
                // Remove observer to prevent memory leaks
                progress.removeObserver(self, forKeyPath: "fractionCompleted")
            }
        }
    }
    
}
