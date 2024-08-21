//
//  EvidenceItemView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

struct EvidenceItemView: View {
    @ObservedObject var viewModel: EvidenceItemViewModel
    var onTap: (String, String) -> Void  // Update onTap to accept data

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(viewModel.isExpanded ? .iconColor2 : .iconColor1)
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
                    Slider(value: .constant(0.2))
                    HStack{
                        // dummy icon biar seimbang
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 24))
                            .foregroundColor(.clear)
                            .disabled(true)
                        Spacer()
                        
                        HStack(spacing:16){
                            Button(action: {
                                // backward 10 sec
                            }) {
                                Image(systemName: "gobackward.10")
                                    .font(.system(size: 24))
                                    .foregroundColor(.buttonColor5)
                            }
                            
                            Button(action: {
                                // implement play music
                            }) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.buttonColor3)
                            }
                            
                            Button(action: {
                                // forward 10 sec
                            }) {
                                Image(systemName: "goforward.10")
                                    .font(.system(size: 24))
                                    .foregroundColor(.buttonColor5)
                            }
                        }
                        
                        Spacer()
                        Button(action: {
                            // implement download
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 24))
                                .foregroundColor(.buttonColor3)
                        }
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
            // example data yang di kirim
            onTap(viewModel.streetName, viewModel.recordingTime)
        }
    }
}
