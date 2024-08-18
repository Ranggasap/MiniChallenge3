//
//  iOSManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import Foundation
import Combine

class iOSManager: recordFunction, ObservableObject {
    @Published var audio = Audio()
    @Published var isLoading = true
    @Published var isDirected = false
    @Published var isRecording = false
    @Published var connectivity = WatchConnectivityManager()
    var cancellables = Set<AnyCancellable>()
    
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
    }
}
