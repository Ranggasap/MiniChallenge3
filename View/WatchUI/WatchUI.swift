//
//  WatchUI.swift
//  Mini3 Watch App
//
//  Created by Rangga Saputra on 20/08/24.
//

import SwiftUI

struct WatchUI: View {
    @State var isRecording: Bool = false
    
    var body: some View {
        VStack{
            if isRecording {
                RecordingWatchUI(isRecording: $isRecording)
                    .transition(.opacity)
            } else {
                IdleWatchUI(isRecording: $isRecording)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isRecording)
    }
}

#Preview {
    WatchUI()
}
