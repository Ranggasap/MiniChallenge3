//
//  DownloadManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 22/08/24.
//

import Foundation
import UIKit

class DownloadManager: NSObject, UIDocumentPickerDelegate {
    func downloadRecording(_ recording: URL) {
        guard let viewController = getRootViewController() else {
            print("Failed to get the root view controller.")
            return
        }
        
        // Copy the recording to a temporary location
        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        let destinationURL = tempDirectory.appendingPathComponent(recording.lastPathComponent)
        
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
