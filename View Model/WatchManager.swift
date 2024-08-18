//
//  WatchManager.swift
//  Mini3 Watch App
//
//  Created by Bryan Vernanda on 18/08/24.
//

import Foundation
import AVFoundation

class WatchManager: recordFunction, ObservableObject {
    @Published var audio = Audio()
    @Published var isRecording = false
    @Published var isLoading = true
    @Published var counter: Int = UserDefaults.standard.integer(forKey: "recordingCounter") + 1
    var audioRecorder: AVAudioRecorder?
    var currentAudioFilename: URL?
    let connectivity = WatchConnectivityManager()
    
    func requestRecordPermission() {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    do {
                        try self.setupAudioSession()
                    } catch {
                        print("Failed to set up audio session: \(error.localizedDescription)")
                    }
                } else {
                    print("Permission denied")
                }
            }
        }
    }
    
    func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        try audioSession.setActive(true)
        
        //this is for auto recording
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            startRecording()
//            isRecording = true
//        }
    }
    
    func setupRecorder() throws {
        let recordingSettings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 192000
        ] as [String : Any]

        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("recording-\(counter).m4a")
        currentAudioFilename = audioFilename

        // Update counter and store it persistently
        counter += 1
        UserDefaults.standard.set(counter, forKey: "recordingCounter")

        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: recordingSettings)
        audioRecorder?.prepareToRecord()
    }
    
    func startRecording() {
        do {
            try setupRecorder()
            
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        audio.recordings = fetchRecordings()
        
        // Send only the current recording to the iPhone
        if let currentFilename = currentAudioFilename {
            connectivity.sendRecordingToiPhone(audio.recordings, currentFilename)
        }
    }
}
