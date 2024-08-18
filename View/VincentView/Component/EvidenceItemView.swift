//
//  EvidenceItemView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

struct EvidenceItemView: View {
    @ObservedObject var viewModel: EvidenceItemViewModel
    var onTap: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.iconColor2)
                    .overlay {
                        Image(.icon2)
                    }
                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.streetName)
                        .foregroundColor(.fontColor4)
                        .font(.lt(size: 16, weight: .semibold))
                    HStack {
                        Text(viewModel.streetDetail)
                        Spacer()
                        Text(viewModel.recordingTime)
                    }
                    .foregroundColor(.fontColor6)
                    .font(.lt(size: 15))
                }
                Spacer()
            }
            if viewModel.isExpanded {
                VStack(spacing: 10) {
//                    Text("Audio Record for \(viewModel.streetName)")
//                        .foregroundColor(.fontColor4)
                    Slider(value: .constant(0.2))
                    HStack(spacing:16){
                        Image(systemName: "gobackward.10")
                            .font(.system(size: 24))
                        Image(systemName: "play")
                            .font(.system(size: 32))
                        Image(systemName: "goforward.10")
                            .font(.system(size: 24))
                    }
                }
            }
        }
        .padding()
        .background(.containerColor2)
        .cornerRadius(10)
        .shadow(radius: 2, y: 4)
        .onTapGesture {
            viewModel.toggleExpand()
            onTap()
        }
    }
}
