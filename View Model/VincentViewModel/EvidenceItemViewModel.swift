//
//  EvidenceItemViewModel.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

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
        isExpanded.toggle()
    }
}

class EvidenceListViewModel: ObservableObject {
    @Published var evidenceItems: [EvidenceItemViewModel] = []
    
    
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
                    EvidenceItemView(viewModel: item) {
                        self.collapseAllExcept(selectedItem: item)
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
                                Text("BSD Boulevard 1170 Street")
                                    .foregroundColor(.fontColor4)
                                    .font(.lt(size: 16, weight: .semibold))
                                Text("290 m away, near GOP Office Park")
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
            VStack(spacing:24){
                VStack(alignment:.leading, spacing:12){
                    Text("Evidence")
                        .foregroundColor(.fontColor4)
                        .font(.lt(size: 20, weight: .bold))
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 73)
                        .foregroundColor(.containerColor2)
                        .shadow(radius: 2, y: 4)
                        .overlay {
                            VStack(alignment:.leading, spacing:4){
                                Text("6 Aug 2024")
                                    .foregroundColor(.fontColor4)
                                    .font(.lt(size: 16, weight: .semibold))
                                HStack{
                                    Text("BSD Green Office Park")
                                    Spacer()
                                    Text("05:24")
                                }
                                .foregroundColor(.fontColor5)
                                .font(.lt(size: 16))
                            }
                            .padding()
                        }
                }
                
                VStack(alignment:.leading, spacing:12){
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
                                    Text("BSD Boulevard 1170 Street")
                                        .foregroundColor(.fontColor4)
                                        .font(.lt(size: 16, weight: .semibold))
                                    Text("290 m away, near GOP Office Park")
                                        .foregroundColor(.fontColor6)
                                        .font(.lt(size: 15))
                                }
                                Spacer()
                            }
                            .padding()
                        }
                }
                
                VStack(alignment:.leading, spacing:12){
                    Text("Other details")
                        .foregroundColor(.fontColor4)
                        .font(.lt(size: 20, weight: .bold))
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 73)
                        .foregroundColor(.containerColor2)
                        .shadow(radius: 2, y: 4)
                        .overlay {
                            // textfield buat notes
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
    

}
