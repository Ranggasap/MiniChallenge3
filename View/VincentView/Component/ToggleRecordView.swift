//
//  ToggleRecord.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

struct ToggleRecordView: View {
    @Binding var isAutoRecording: Bool
    var body: some View {
        HStack(spacing:8){
            Spacer()
            Text("Auto Recording")
                .font(.lt(size: 16, weight: .medium))
                .foregroundColor(.fontColor2)
            Toggle("", isOn: $isAutoRecording)
                .labelsHidden()
                .onChange(of: isAutoRecording) {
                    print("\(isAutoRecording)")
                }
        }
        .padding(.horizontal, 32)
    }
}
