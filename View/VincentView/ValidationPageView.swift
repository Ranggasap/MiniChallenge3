//
//  ValidationPageView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI
import CloudKit

struct ValidationPageView: View {
    @State private var isAutoRecording = true
    @Binding var navigateToValidation: Bool
    
    @State private var showLoginPage = false
    @AppStorage("userId") var userId : String = ""
    @State private var notes: String = ""
    
    
    @State var onPinValidation: Bool
    @Binding var alreadyRecord: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var currentCase: Int = 1
    @State private var showingAlert = false
    @ObservedObject var iOSVM: iOSManager
    @ObservedObject var listViewModel: EvidenceListViewModel
    @ObservedObject var locationVM: LocationManager
    
    
//    @StateObject var reportVm: ReportManager
    

    init(navigateToValidation: Binding<Bool>, onPinValidation: Bool, alreadyRecord: Binding<Bool>, iOSVM: iOSManager, listViewModel: EvidenceListViewModel, locationVM: LocationManager) {

        self._navigateToValidation = navigateToValidation
        self._onPinValidation = State(initialValue: onPinValidation)
//        _reportVm = StateObject(wrappedValue: reportVm)
        self._alreadyRecord = alreadyRecord
        self.iOSVM = iOSVM
        self.listViewModel = listViewModel
        self.locationVM = locationVM
    }
    
    
    var body: some View {
        ZStack {
            bgStyle(pattern: "ItemBackground1", colorBg: "ColorBackground1")
            
            VStack(alignment: .leading, spacing: 16) {
                Button(action: {
                    if onPinValidation && currentCase == 3{
                        
                        alreadyRecord = true
                        
                        navigateToValidation = false
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        handleBackAction()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                        Text(onPinValidation  && currentCase == 3 ? "Cancel" : "Back")
                    }
                    .foregroundColor(getBackButtonColor())
                }
                .disabled(onPinValidation && currentCase == 2)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
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
                if !onPinValidation {
                    HStack(spacing: 8) {
                        ForEach(1...3, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 12)
                                .foregroundColor(index <= currentCase ? .indicatorColor2 : .indicatorColor1)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
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
                                    .foregroundColor(.iconColor2)
                                
                                Text(listViewModel.getCaseTitle(for: currentCase))
                                    .foregroundColor(.fontColor4)
                                    .font(.lt(size: 24, weight: .bold))
                                
                                Spacer()
                            }
                            
                            ScrollView {
                                listViewModel.getCurrentCaseView(for: currentCase, locationVM, iOSVM)
                            }
                            .scrollIndicators(.hidden)
                            
                            Button(action: {
                                
                                handleNextAction()
                                
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
                                    message: Text("Make sure every data you choose and fill are correct."),
                                    primaryButton: .default(Text("Submit")) {
                                        handleAlertYesAction()
                                    },
                                    secondaryButton: .cancel(Text("Cancel"))
                                )
                                
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                        .padding(.bottom, DynamicIslandChecker.getBotPadding())
                    }
            }
            
            if showLoginPage {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    let container = CKContainer(identifier: "iCloud.com.dandenion.MiniChallenge3")
                    SignInWithAppleComponent(userVm: UserAppManager(container: container), showLoginPage: $showLoginPage)
                    
                }
                .frame(width: 300, height: 400)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
        
    }
    
    private func handleBackAction() {
        if currentCase > 1 {
            currentCase -= 1
        } else {
            navigateToValidation = false
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func handleNextAction() {
        if !onPinValidation {
            if currentCase < 3 {
                currentCase += 1
            } else {
                if userId.isEmpty{
                    showLoginPage.toggle()
                } else{
                    showingAlert = true
                }
            }
        }
    }
    
    private func handleAlertYesAction() {
        if currentCase == 2 {
            currentCase += 1
        } else {
            
            alreadyRecord = true
            navigateToValidation = false
            currentCase = 2
            listViewModel.saveReportToCloud()
            self.presentationMode.wrappedValue.dismiss()
            
        }
    }
    
    private func getBackButtonColor() -> Color {
        if onPinValidation && currentCase != 3 {
            return .clear
        } else if onPinValidation {
            return currentCase == 3 ? .buttonColor6 : .clear
        } else {
            return .buttonColor6
        }
    }
}

#Preview {
    

    ValidationPageView(navigateToValidation: .constant(true), onPinValidation: false, reportVm: ReportManager(), alreadyRecord: .constant(true), iOSVM: iOSManager(), listViewModel: EvidenceListViewModel(), locationVM: LocationManager())

    
}

