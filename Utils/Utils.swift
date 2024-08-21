//
//  Utils.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import Foundation

enum stringSent: String {
    case recording = "recording"
}

enum messageSent: String {
    case recordStateChangeRequest = "recordStateChangeRequest"
    case recordState = "recordState"
    case done = "done"
    case stored = "stored"
}

enum PlayerScrubState {
    case reset
    case scrubStarted
    case scrubEnded(TimeInterval)
}
