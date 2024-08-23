//
//  RecordFunction.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import AVFoundation

class recordFunction {
    var audioPlayer: AVAudioPlayer?
    
    func playRecording(_ recording: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recording)
            audioPlayer?.play()
        } catch {
            print("Failed to play recording: \(error.localizedDescription)")
        }
    }
    
    func fetchRecordings() -> [URL] {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil, options: [])
            let newRecordings = files.filter { $0.pathExtension == "m4a" }
            
            let allRecordings = newRecordings.sorted(by: { $0.lastPathComponent > $1.lastPathComponent })
            
            if allRecordings.count > 3 {
                do {
                    let oldestRecording = allRecordings.last!
                    try FileManager.default.removeItem(at: oldestRecording)
                    print("Deleted recording: \(oldestRecording.lastPathComponent)")
                } catch {
                    print("Failed to delete recording: \(error.localizedDescription)")
                }
            }
            
            print("fetched Recording: \(allRecordings)")
            
            return allRecordings
        } catch {
            print("Failed to fetch recordings: \(error.localizedDescription)")
            return []
        }
    }
}
