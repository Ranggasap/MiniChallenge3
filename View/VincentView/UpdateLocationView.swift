//
//  UpdateLocationView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 21/08/24.
//

import SwiftUI

struct UpdateLocationView: View {
    @ObservedObject var iOSVM = iOSManager()
    @ObservedObject private var listViewModel = EvidenceListViewModel()
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                // mapviewnya (harus disesuain sama bgstyle biar pas)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                bgStyle(pattern: "ItemBackground1", colorBg: "ColorBackground1") // testview
                
                VStack(spacing:16) {
                    Spacer()
                    VStack(spacing: 32) {
                        VStack(spacing:12){
                            HStack{
                                Image(systemName: "figure.walk")
                                Slider(value: .constant(0.3))
                                Image(systemName: "figure.wave")
                            }
                            .padding(.horizontal, 32)
                            HStack{
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
                            }
                        }
                        
                        VStack(spacing:16){
                            Button(action: {
                                // Update pin point action
                            }) {
                                RoundedRectangle(cornerRadius: 14)
                                    .foregroundColor(.buttonColor1)
                                    .frame(width: UIScreen.main.bounds.width - 64, height: 62)
                                    .overlay {
                                        Text("Change Pin Point")
                                            .font(.lt(size: 20, weight: .bold))
                                            .foregroundColor(.fontColor1)
                                    }
                                    .padding(.horizontal, 32)
                            }
                            
                            Button(action: {
                                // Cancel action
                            }) {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.buttonColor2)
                                    .frame(width: UIScreen.main.bounds.width - 64, height: 62)
                                    .overlay {
                                        Text("Cancel")
                                            .font(.lt(size: 20, weight: .bold))
                                            .foregroundColor(.buttonColor2)
                                    }
                                    .padding(.horizontal, 32)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                listViewModel.navigateToValidation = true
                            })
                        }
                    }
                    .padding(.top, 28)
                    .padding(.bottom, DynamicIslandChecker.getBotPadding())
                    .background(.containerColor1)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    UpdateLocationView(iOSVM: iOSManager())
}

