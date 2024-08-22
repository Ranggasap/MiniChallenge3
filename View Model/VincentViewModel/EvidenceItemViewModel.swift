//
//  EvidenceItemViewModel.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI
import AVFoundation

class EvidenceItemViewModel: ObservableObject {
    @Published var isExpanded: Bool = false
    var id = UUID()
    var timestamp: String
    var streetName: String
    var streetDetail: String
    var recordingTime: String
    var audioPlayer: Player
    var recording: URL
    
    init(timestamp: String ,streetName: String, streetDetail: String, recordingTime: String, audioPlayer: Player, recording: URL) {
        self.timestamp = timestamp
        self.streetName = streetName
        self.streetDetail = streetDetail
        self.recordingTime = recordingTime
        self.audioPlayer = audioPlayer
        self.recording = recording
    }
    
    func toggleExpand() {
        isExpanded = true
    }
}

class EvidenceListViewModel: ObservableObject {
    @Published var navigateToValidation = false
    @Published var navigateToPinValidation = false
    @Published var evidenceItems: [EvidenceItemViewModel] = []
    @Published var audioPlayer: [Player] = []

    @Published var selectedDate: String = ""
    @Published var selectedStreetName: String = ""
    @Published var selectedStreetDetail: String = ""
    @Published var selectedRecordingTime: String = ""

    func collapseAllExcept(selectedItem: EvidenceItemViewModel) {
        for item in evidenceItems {
            if item !== selectedItem {
                item.isExpanded = false
            }
        }
    }
    
    @ViewBuilder
    func getCurrentCaseView(for currentCase: Int, _ locationVM: LocationManager, _ iOSVM: iOSManager) -> some View {
        switch currentCase {
        case 1:
            VStack(spacing: 24) {
                ForEach(Array(evidenceItems), id: \.id) { item in
                    EvidenceItemView(viewModel: item, player: item.audioPlayer) { streetName, recordingTime in
                        // Store the selected data
                        self.collapseAllExcept(selectedItem: item)
                        self.selectedDate = item.timestamp
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
                var recordings: [URL] = []
                var formattedDate: String = ""
                var audioTime: String = ""
                var audioPlayer: Player?
                recordings = iOSVM.fetchRecordings()
                
                // Loop through the recordings with index
                for (index, recording) in recordings.enumerated() {
                    
                    if let lastCoordinate = locationVM.storeLocation[index].routeCoordinates.last {
                        let timestamp = lastCoordinate.timestamp
                        
                        // Create a DateFormatter to format the date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .long
                        dateFormatter.timeStyle = .none
                        
                        // Format the timestamp to a string
                        formattedDate = dateFormatter.string(from: timestamp)
                        
                    } else {
                        print("No coordinates available.")
                    }
                    
                    audioTime = self.formatDuration(recording)
                    audioPlayer = Player(avPlayer: AVPlayer(url: recording))

                    let evidenceItem = EvidenceItemViewModel(
                        timestamp: formattedDate,
                        streetName: locationVM.loadLocManager.lastGeocodedAddressName,
                        streetDetail: locationVM.loadLocManager.lastGeocodedAddressDetail,
                        recordingTime: audioTime,
                        audioPlayer: audioPlayer!,
                        recording: recording
                    )
                    
                    self.evidenceItems.append(evidenceItem)
                }

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
    
    func formatDuration(_ recording: URL) -> String {
        let asset = AVURLAsset(url: recording)
        
        guard let assetReader = try? AVAssetReader(asset: asset) else {
            return ""
        }
        
        let duration = Double(assetReader.asset.duration.value)
        let timescale = Double(assetReader.asset.duration.timescale)
        let totalDuration = duration / timescale
        
        let minutes = Int(totalDuration) / 60
        let seconds = Int(totalDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}
