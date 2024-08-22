//
//  Player.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 21/08/24.
//

import AVFoundation
import Combine

class Player: ObservableObject {
    @Published var displayTime: TimeInterval = 0
    @Published var observedTime: TimeInterval = 0
    @Published var itemDuration: TimeInterval = 0
    @Published var isPlaying: Bool = false
    
    private var avPlayer: AVPlayer
    private var periodicTimeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    var scrubState: PlayerScrubState = .reset {
        didSet {
            switch scrubState {
            case .reset:
                return
            case .scrubStarted:
                return
            case .scrubEnded(let seekTime):
                avPlayer.seek(to: CMTime(seconds: seekTime, preferredTimescale: 1000))
            }
        }
    }

    init(avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
        addPeriodicTimeObserver()
        observePlayerStatus()
    }
    
    deinit {
        removePeriodicTimeObserver()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            if displayTime >= itemDuration {
                displayTime = 0
                avPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
            }
            play()
        }
    }
    
    func play() {
        avPlayer.play()
        isPlaying = true
    }

    func pause() {
        avPlayer.pause()
        isPlaying = false
    }
    
    func fastForward() {
        let currentTime = avPlayer.currentTime()
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        let remainingTime = itemDuration - currentTimeInSeconds
        
        // Check if the remaining time is less than 10 seconds
        let fastForwardInterval: Double = 10
        let newTime = remainingTime < fastForwardInterval ? itemDuration : currentTimeInSeconds + fastForwardInterval
        
        avPlayer.seek(to: CMTime(seconds: newTime, preferredTimescale: 1000))
    }

    
    func rewind() {
        let currentTime = avPlayer.currentTime()
        let newTime = CMTimeGetSeconds(currentTime) - 10
        avPlayer.seek(to: CMTime(seconds: newTime, preferredTimescale: 1000))
    }
    
    private func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        periodicTimeObserver = avPlayer.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            // Always update observed time.
            self.observedTime = time.seconds
            
            switch self.scrubState {
            case .reset:
                self.displayTime = time.seconds
            case .scrubStarted:
                break
            case .scrubEnded(let seekTime):
                self.scrubState = .reset
                self.displayTime = seekTime
            }
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let periodicTimeObserver = periodicTimeObserver {
            avPlayer.removeTimeObserver(periodicTimeObserver)
            self.periodicTimeObserver = nil
        }
    }
    
    private func observePlayerStatus() {
        avPlayer.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                self.isPlaying = (status == .playing)
            }
            .store(in: &cancellables)
        
        avPlayer.publisher(for: \.currentItem?.duration)
            .compactMap { $0?.seconds }
            .receive(on: DispatchQueue.main)
            .assign(to: &$itemDuration)
    }
}
