//
//  iOSManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import Foundation

class iOSManager: recordFunction, ObservableObject {
    @Published var audio = Audio()
    @Published var isLoading = true
}
