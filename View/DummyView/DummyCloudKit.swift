//
//  DummyCloudKit.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 21/08/24.
//

import SwiftUI

struct DummyCloudKit: View {
    @StateObject var userVm: UserAppManager
    @StateObject var reportVm: ReportManager
    
    init(userVm: UserAppManager, reportVm: ReportManager) {
        _userVm = StateObject(wrappedValue: userVm)
        _reportVm = StateObject(wrappedValue: reportVm)
    }
    
    var body: some View {
        VStack {
            
            List(userVm.users, id: \.userID) { user in
                Text(user.firstName)

            }
            .onAppear {
                userVm.fetchUsers()
            }
            
            Text("current user is \(userVm.currentUser?.firstName)")
                
            
            Button(action: {
                let newUser = UserApp(firstName: "Luci", lastName: "Hahaha", email: "admin_hahaha@gmail.com")
                userVm.createUser(user: newUser) { result in
                    switch result {
                    case .success(let record):
                        print("User created: \(String(describing: record))")
                    case .failure(let error):
                        print("Error creating user: \(error.localizedDescription)")
                    }
                    
                }
                
                
            }) {
                Text("Add User")
            }
            
            
        }

        
    }
}

#Preview {
    DummyCloudKit(userVm: UserAppManager(), reportVm: ReportManager())
}
