//
//  iOSManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import UIKit
import Combine

class iOSManager: NSObject, ObservableObject, UIDocumentPickerDelegate {
    @Published var audio = Audio()
    @Published var isLoading = true
    @Published var isDirected = false
    @Published var isAutoRecording = false
    @Published var isRecording = false
    @Published var endRecord = true
    @Published var isStored = false
    @Published var connectivity = WatchConnectivityManager()
    var cancellables = Set<AnyCancellable>()
    
    // Instance of recordFunction for composition
    let recordFunc = recordFunction()
    
    override init() {
        super.init()
        
        connectivity.isRecordingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.isRecording != newValue {
                    if self.isRecording {
                        self.endRecord = true
                    } else {
                        self.isRecording = newValue
                        self.endRecord = !newValue
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // Delegating the methods to the composed recordFunction instance
    func playRecording(_ recording: URL) {
        recordFunc.playRecording(recording)
    }
    
    func fetchRecordings() -> [URL] {
        return recordFunc.fetchRecordings()
    }
    
    func toggleRecordingState(_ connectivity: WatchConnectivityManager, _ isRecording: Bool) {
        let newState = !isRecording
        connectivity.sendStateChangeRequest(newState, messageSent.recordState.rawValue, false)
    }
    
    func toggleStoredState(_ connectivity: WatchConnectivityManager, _ isStored: Bool) {
        connectivity.sendStateChangeRequest(false, messageSent.stored.rawValue, isStored)
    }
    
    func downloadRecording(_ recording: URL) {
        guard let viewController = getRootViewController() else {
            print("Failed to get the root view controller.")
            return
        }
        
        // Present the document picker to save the copied file
        let documentPicker = UIDocumentPickerViewController(forExporting: [recording])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        viewController.present(documentPicker, animated: true, completion: nil)
    }
    
    // Function to get the root view controller
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first?.rootViewController
    }
    
    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else {
            return
        }
        
        print("File copied to \(selectedURL)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }
}
