//
//  ValidationPageViewModel.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import SwiftUI

class ValidationPageViewModel: ObservableObject {
    @Published var currentCase: Int = 1
    @Published var showingAlert = false
    
    func getCaseTitle() -> String {
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
    
    func getCaseButton() -> String {
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
    
    func goToNextCase() {
        if currentCase < 3 {
            currentCase += 1
        } else {
            showingAlert = true
        }
    }
    
    func goToPreviousCase(presentationMode: Binding<PresentationMode>) {
        if currentCase > 1 {
            currentCase -= 1
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
