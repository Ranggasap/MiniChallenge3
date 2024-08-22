//
//  EvidenceItemViewModel.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI
import CoreLocation
import CloudKit

class EvidenceItemViewModel: ObservableObject {
    @Published var isExpanded: Bool = false
    var streetName: String
    var streetDetail: String
    var recordingTime: String
    
    
    init(streetName: String, streetDetail: String, recordingTime: String) {
        self.streetName = streetName
        self.streetDetail = streetDetail
        self.recordingTime = recordingTime
    }
    
    func toggleExpand() {
        isExpanded = true
    }
}

class EvidenceListViewModel: ObservableObject {
    @Published var navigateToValidation = false
    @Published var navigateToPinValidation = false
    @Published var evidenceItems: [EvidenceItemViewModel] = []
    
    
    @Published var selectedStreetName: String = ""
    @Published var selectedStreetDetail: String = ""
    @Published var selectedRecordingTime: String = ""
    
    //    var reportVm: ReportManager
    //    var userVm: UserAppManager
    //
    //    init(reportVm: ReportManager, userVm: UserAppManager) {
    //        self.reportVm = reportVm
    //        self.userVm = userVm
    //    }
    
    let reportVm: ReportManager
    let userVm: UserAppManager
    
    init() {
        let container = CKContainer(identifier: "iCloud.com.dandenion.MiniChallenge3")
        self.reportVm = ReportManager(container: container)
        self.userVm = UserAppManager(container: container)
        
        userVm.fetchUsers()
    }
    
    @StateObject var locationManager = GeofencingManager()
    
    
    
    func collapseAllExcept(selectedItem: EvidenceItemViewModel) {
        for item in evidenceItems {
            if item !== selectedItem {
                item.isExpanded = false
            }
        }
    }
    
    @ViewBuilder
    func getCurrentCaseView(for currentCase: Int) -> some View {
        switch currentCase {
        case 1:
            VStack(spacing: 24) {
                ForEach(Array(evidenceItems.prefix(3)), id: \.streetName) { item in
                    EvidenceItemView(viewModel: item) { streetName, recordingTime in
                        // Store the selected data
                        self.collapseAllExcept(selectedItem: item)
                        self.selectedStreetName = streetName
                        self.selectedStreetDetail = item.streetDetail
                        self.selectedRecordingTime = recordingTime
                        
                        // Debugging
                        print("Tapped on street: \(streetName) at time: \(recordingTime)")
                    }
                }
                Spacer()
            }
            .onAppear {
                self.evidenceItems = [
                    EvidenceItemViewModel(streetName: "BSD Boulevard 1170 Street", streetDetail: "Recorded near GOP Office Park", recordingTime: "00:34"),
                    EvidenceItemViewModel(streetName: "Main St", streetDetail: "Near Central Park", recordingTime: "00:45"),
                    EvidenceItemViewModel(streetName: "Wall St", streetDetail: "Financial District", recordingTime: "01:02")
                ]
            }
            
        case 2:
            VStack(spacing: 24) {
                Rectangle()
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(height: UIScreen.main.bounds.height * 2 / 5)
                    .shadow(radius: 2, y: 4)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 73)
                    .foregroundColor(.containerColor2)
                    .shadow(radius: 2, y: 4)
                    .overlay {
                        HStack(spacing: 12) {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.iconColor2)
                                .overlay {
                                    Image(.icon1)
                                }
                            VStack(alignment: .leading, spacing: 3) {
                                Text(selectedStreetName)
                                    .foregroundColor(.fontColor4)
                                    .font(.lt(size: 16, weight: .semibold))
                                Text(selectedStreetDetail)
                                    .foregroundColor(.fontColor6)
                                    .font(.lt(size: 15))
                            }
                            Spacer()
                        }
                        .padding()
                    }
                Spacer()
            }
            
        case 3:
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Evidence")
                        .foregroundColor(.fontColor4)
                        .font(.lt(size: 20, weight: .bold))
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 73)
                        .foregroundColor(.containerColor2)
                        .shadow(radius: 2, y: 4)
                        .overlay {
                            VStack(alignment:.leading, spacing:4) {
                                Text(selectedStreetName)
                                    .foregroundColor(.fontColor4)
                                    .font(.lt(size: 16, weight: .semibold))
                                HStack {
                                    Text(selectedStreetDetail)
                                    Spacer()
                                    Text(selectedRecordingTime)
                                }
                                .foregroundColor(.fontColor5)
                                .font(.lt(size: 16))
                            }
                            .padding()
                        }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Location")
                        .foregroundColor(.fontColor4)
                        .font(.lt(size: 20, weight: .bold))
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 73)
                        .foregroundColor(.containerColor2)
                        .shadow(radius: 2, y: 4)
                        .overlay {
                            HStack(spacing: 12) {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.iconColor2)
                                    .overlay {
                                        Image(.icon1)
                                    }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(selectedStreetName) // Use selected data
                                        .foregroundColor(.fontColor4)
                                        .font(.lt(size: 16, weight: .semibold))
                                    Text(selectedStreetDetail) // Use selected data
                                        .foregroundColor(.fontColor6)
                                        .font(.lt(size: 15))
                                }
                                Spacer()
                            }
                            .padding()
                        }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Other details")
                        .foregroundColor(.fontColor4)
                        .font(.lt(size: 20, weight: .bold))
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 73)
                        .foregroundColor(.containerColor2)
                        .shadow(radius: 2, y: 4)
                        .overlay {
                            // textfield for notes
                            Text("")
                                .disableAutocorrection(true)
                        }
                }
                Spacer()
            }
            
        default:
            EmptyView()
        }
    }
    
    func getCaseButton(for currentCase: Int) -> String {
        switch currentCase {
        case 1:
            return "Select Evidence"
        case 2:
            return "Confirm Location"
        case 3:
            return "Submit"
        default:
            return ""
        }
    }
    
    func getCaseTitle(for currentCase: Int) -> String {
        switch currentCase {
        case 1:
            return "Select the voice evidence!"
        case 2:
            return "Where did it happen?"
        case 3:
            return "Are you sure?"
        default:
            return ""
        }
    }
    
    func saveReportToCloud(){
        
        let userID = userVm.currentUser?.userID
        let newReport = Report(reportDate: Date(), reportKronologi: "Apple Developer Academy", location: CLLocation(latitude: -6.302147, longitude: 106.652291), userID: userID!)
        reportVm.createReport(report: newReport) { result in
            switch result {
            case .success(let record):
                print("Report created: \(String(describing: record))")
            case .failure(let error):
                print("Error creating report: \(error.localizedDescription)")
            }
            
            
        }
        
        
        
    }
    
}
