//
//  WatchManager.swift
//  Mini3 Watch App
//
//  Created by Bryan Vernanda on 18/08/24.
//

import Foundation
import Combine
import AVFoundation

class WatchManager: recordFunction, ObservableObject {
    @Published var audio = Audio()
    @Published var isRecording = false
    @Published var isAutoRecord = false
    @Published var isLoading = true
    @Published var connectivity = WatchConnectivityManager()
    var audioRecorder: AVAudioRecorder?
    var currentAudioFilename: URL?
    var cancellables = Set<AnyCancellable>()
    var initializeState = false
    
    override init() {
        super.init()
        
        connectivity.isRecordingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.isRecording != newValue {
                    self.isRecording = newValue
                }
            }
            .store(in: &cancellables)
        
        connectivity.isStoredSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.initializeState {
                    if newValue == true {
                        connectivity.sendRecordingToiPhone(audio.recordings, currentAudioFilename!)
                    } else {
                        removeLastRecording()
                    }
                } else {
                    self.initializeState = true
                }

            }
            .store(in: &cancellables)
        
        connectivity.isAutoRecSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.isAutoRecord != newValue {
                    self.isAutoRecord = newValue
                }

            }
            .store(in: &cancellables)
    }
    
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

        // Get the document directory path
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        // Create a timestamp string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd-HHmmss"
        let timestamp = dateFormatter.string(from: Date())

        // Create the audio filename with the timestamp
        let audioFilename = documentPath.appendingPathComponent("recording-\(timestamp).m4a")
        currentAudioFilename = audioFilename

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
    }
    
    func toggleRecordingState(_ connectivity: WatchConnectivityManager, _ isRecording: Bool) {
        let newState = !isRecording
        connectivity.sendRecordingStateChangeRequest(newState)
    }
    
    func removeLastRecording() {
        if !audio.recordings.isEmpty {
            print("before: \(audio.recordings.count)")
            
            do {
                //will need to be adjusted if using different file name (if changed)
                try FileManager.default.removeItem(at: audio.recordings.removeLast())
            } catch {
                print("Failed to delete recording: \(error.localizedDescription)")
            }
            
            isRecording = false //to reset the list (optional since not implement design yet)
            audio.recordings = fetchRecordings()
            
            print("after: \(audio.recordings.count)")
        } else {
            print("No recordings to remove.")
        }
    }
}
