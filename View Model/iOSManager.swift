//
//  iOSManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import UIKit
import Combine

class iOSManager: recordFunction, ObservableObject {
    @Published var alreadyRecord = false
    @Published var audio = Audio()
    @Published var isLoading = true
    @Published var isDirected = false
    @Published var isAutoRecord = false
    @Published var isRecording = false
    @Published var endRecord = true
    @Published var isStored = false
    @Published var connectivity = WatchConnectivityManager()
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        self.alreadyRecord = alreadyRecord
        
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
    
    func toggleRecordingState(_ connectivity: WatchConnectivityManager, _ isRecording: Bool) {
        let newState = !isRecording
        connectivity.sendStateChangeRequest(newState, messageSent.recordState.rawValue, false, false)
    }
    
    func toggleStoredState(_ connectivity: WatchConnectivityManager, _ isStored: Bool) {
        connectivity.sendStateChangeRequest(false, messageSent.stored.rawValue, isStored, false)
    }
    
    func toggleAutoRecordState(_ connectivity: WatchConnectivityManager, _ isToggled: Bool) {
        connectivity.sendStateChangeRequest(false, messageSent.autoRec.rawValue, false, isToggled)
    }
}
