//
//  SignInWithAppleComponent.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 21/08/24.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleComponent: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("email") var email : String = ""
    @AppStorage("firstName") var firstName : String = ""
    @AppStorage("lastName") var lastName : String = ""
    @AppStorage("userId") var userId : String = ""
    
    @Binding var showLoginPage: Bool
    
    @StateObject var userVm: UserAppManager
    
    init(userVm: UserAppManager) {
        _userVm = StateObject(wrappedValue: userVm)
    }
    
    var body: some View {
        VStack{
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.email, .fullName]
                
            } onCompletion: { result in
                switch result{
                case .success(let auth):
                    switch auth.credential{
                    case let credential as ASAuthorizationAppleIDCredential:
                        let userId = credential.user
                        let email = credential.email
                        let firstName = credential.fullName?.givenName
                        let lastName = credential.fullName?.familyName
                        
                        self.email = email ?? ""
                        self.firstName = firstName ?? ""
                        self.lastName = lastName ?? ""
                        self.userId = userId ?? ""
                        
                        
                        let newUser = UserApp(firstName: firstName ?? "", lastName: lastName ?? "", email: email ?? "")
                        userVm.createUser(user: newUser) { result in
                            switch result {
                            case .success(let record):
                                print("User created: \(String(describing: record))")
                            case .failure(let error):
                                print("Error creating user: \(error.localizedDescription)")
                            }
                            
                            userVm.fetchUsers()
                            
                            showLoginPage = false
                            
                        }
                        
                        
                    default:
                        break
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
                
            }
            .signInWithAppleButtonStyle(colorScheme == .dark ?  .white : .black)
            .frame(width: 330, height:45)
            .padding()
            .cornerRadius(8)
        }
    }
}

#Preview {
    SignInWithAppleComponent(userVm: UserAppManager())
}
