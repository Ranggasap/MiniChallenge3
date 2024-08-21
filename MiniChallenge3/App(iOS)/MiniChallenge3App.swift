//
//  MiniChallenge3App.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 29/07/24.
//

import SwiftUI
import SwiftData

@main
struct MiniChallenge3App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            iOSMainView()
//            ContentView() // Frontend
        }
        .modelContainer(for: SavedLocation.self)
    }
}
