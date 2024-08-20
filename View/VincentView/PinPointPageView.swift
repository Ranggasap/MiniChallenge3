//
//  PinPointPageView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 20/08/24.
//

import SwiftUI

struct PinPointPageView: View {
    @State private var isAutoRecording = true
    @Binding var navigateToPinValidation: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var currentCase: Int = 3
    @State private var showingAlert = false
    @StateObject private var listViewModel = EvidenceListViewModel()
    
    var body: some View {
        NavigationView{
            ZStack {
                bgStyle(pattern: "ItemBackground1", colorBg: "ColorBackground1")
                
                VStack(alignment:.leading, spacing:16){
//                    Button(action: {
//                        navigateToPinValidation = false
//                        self.presentationMode.wrappedValue.dismiss()
//                    }) {
//                        HStack {
//                            Image(systemName: "chevron.left")
//                                .imageScale(.large)
//                            Text("Back")
//                        }
//                        .foregroundColor(.buttonColor6)
//                    }
                    
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
                                    
                                    Text(listViewModel.getCaseTitle(for: 2))
                                        .foregroundColor(.fontColor4)
                                        .font(.lt(size: 24, weight: .bold))
                                    
                                    Spacer()
                                }
                                
                                ScrollView {
                                    listViewModel.getCurrentCaseView(for: 2)
                                }
                                Button(action: {
                                    showingAlert = true
                                }) {
                                    RoundedRectangle(cornerRadius: 14)
                                        .frame(width: UIScreen.main.bounds.width - 64, height: 62)
                                        .foregroundColor(.buttonColor1)
                                        .overlay {
                                            Text(listViewModel.getCaseButton(for: 2))
                                                .font(.lt(size: 20, weight: .bold))
                                                .foregroundColor(.fontColor1)
                                        }
                                }
                                .alert("Do you want to report?", isPresented: $showingAlert) {
                                    Button("No"){
                                        showingAlert = false
                                    }
                                    Button("Yes"){
                                        listViewModel.navigateToValidation = true
                                        showingAlert = false
                                    }
                                } message: {
                                    Text("Helps other women avoid catcalled by reporting this incident")
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
            .navigationDestination(isPresented: $navigateToPinValidation) {
//                ValidationPageView(navigateToValidation: $iOSVM.navigateToValidation, currentCase: 1)
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    PinPointPageView(navigateToPinValidation: .constant(true))
}
