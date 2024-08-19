//
//  ValidationPageView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

struct ValidationPageView: View {
    @State private var pattern = "ItemBackground1"
    @State private var colorBg = "ColorBackground1"
    @State private var isAutoRecording = true
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var currentCase: Int = 1
    @State private var showingAlert = false
    @StateObject private var listViewModel = EvidenceListViewModel()
    
    var body: some View {
        ZStack {
            bgStyle(pattern: "ItemBackground1", colorBg: "ColorBackground1")
            
            VStack(alignment:.leading, spacing:16){
                Button(action: {
                    if currentCase > 1 {
                        currentCase -= 1
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                        Text("Back")
                    }
                    .foregroundColor(.buttonColor6)
                }
                
                HStack {
                    VStack(alignment:.leading, spacing:8){
                        Text("Share your story")
                            .font(.lt(size: 32, weight: .bold))
                        Text("Your story empowers and helps other women")
                            .font(.lt(size: 16))
                    }
                    .foregroundColor(.fontColor1)
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, DynamicIslandChecker.getTopPadding())
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                // Indicator
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 12)
                            .foregroundColor(index <= currentCase ? .indicatorColor2 : .indicatorColor1)
                    }
                }
                .padding(.horizontal, 16)
                
                Rectangle()
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .foregroundColor(.containerColor1)
                    .frame(height: UIScreen.main.bounds.height * 3 / 4)
                    .overlay {
                        VStack(spacing: 24) {
                            HStack(spacing: 8) {
                                Image(systemName: "mappin.and.ellipse.circle.fill")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.iconColor1)
                                
                                Text(listViewModel.getCaseTitle(for: currentCase))
                                    .foregroundColor(.fontColor4)
                                    .font(.lt(size: 24, weight: .bold))
                                
                                Spacer()
                            }
                            
                            ScrollView {
                                listViewModel.getCurrentCaseView(for: currentCase)
                            }
                            Button(action: {
                                if currentCase < 3 {
                                    currentCase += 1
                                } else {
                                    showingAlert = true
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: UIScreen.main.bounds.width - 64, height: 62)
                                    .foregroundColor(.buttonColor1)
                                    .overlay {
                                        Text(listViewModel.getCaseButton(for: currentCase))
                                            .font(.lt(size: 20, weight: .bold))
                                            .foregroundColor(.fontColor1)
                                    }
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(
                                    title: Text("Are you sure?"),
                                    message: Text("A message should be a short,\ncomplete sentence."),
                                    primaryButton: .default(
                                        Text("Submit")
                                    ),
                                    secondaryButton: .cancel(
                                        Text("Cancel")
                                    )
                                )
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                        .padding(.bottom, DynamicIslandChecker.getBotPadding())
                    }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

#Preview {
    ValidationPageView()
}

