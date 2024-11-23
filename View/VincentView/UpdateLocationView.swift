//
//  UpdateLocationView.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 21/08/24.
//

import SwiftUI

struct UpdateLocationView: View {
    @ObservedObject var listViewModel: EvidenceListViewModel
    @ObservedObject var player: Player
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                // mapviewnya (harus disesuain sama bgstyle biar pas)
                RoutePolyline(routeCoordinates: listViewModel.LocationDetailVM.routeUpToSliderValue(), startEndPins: listViewModel.LocationDetailVM.startEndPinLocations())
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//                bgStyle(pattern: "ItemBackground1", colorBg: "ColorBackground1") // testview
                
                VStack(spacing:16) {
                    Spacer()
                    VStack(spacing: 32) {
                        VStack(spacing:12){
                            HStack{
                                Image(systemName: "figure.walk")
                                if self.player.itemDuration > 0 {
                                    Slider(value: self.$player.displayTime, in: 0...self.player.itemDuration) { scrubStarted in
                                        if scrubStarted {
                                            self.player.scrubState = .scrubStarted
                                        } else {
                                            self.player.scrubState = .scrubEnded(self.player.displayTime)
                                        }
                                    }
                                } else {
                                    Text("Slider will appear here when the player is ready")
                                        .font(.footnote)
                                }
                                Image(systemName: "figure.wave")
                            }
                            .padding(.horizontal, 32)
                            HStack{
                                Spacer()
                                
                                HStack(spacing:16){
                                    Button(action: {
                                        // backward 10 sec
                                        self.player.rewind()
                                    }) {
                                        Image(systemName: "gobackward.10")
                                            .font(.system(size: 24))
                                            .foregroundColor(.buttonColor5)
                                    }
                                    
                                    Button(action: {
                                        // implement play music
                                        self.player.togglePlayPause()
                                    }) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.buttonColor3)
                                    }
                                    
                                    Button(action: {
                                        // forward 10 sec
                                        self.player.fastForward()
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
                                listViewModel.isDirectedBinding.wrappedValue = false
                                dismiss()
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
            .onAppear {
                print("\(listViewModel.LocationDetailVM.sliderValue), \(listViewModel.LocationDetailVM.maxSliderValue)")
            }
            .onChange(of: player.displayTime) { _, newValue in
//                listViewModel.LocationDetailVM.sliderValue = newValue
                print("\(player.displayTime)")
            }
        }
        .navigationViewStyle(.stack)
    }
}

