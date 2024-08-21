//
//  UserAppManager.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 20/08/24.
//

import Foundation
import CloudKit
import Combine
import SwiftUI

class UserAppManager: CloudKitConnection, ObservableObject {
    @Published var users: [UserApp] = []
    @Published var currentUser: UserApp?
    
    // Fetch the current user's email from AppStorage
    @AppStorage("email") var storedEmail: String = ""
    
    func createUser(user: UserApp, completion: @escaping (Result<CKRecord?, Error>) -> Void) {
        let record = CKRecord(recordType: "UserApp")
        record["firstName"] = user.firstName as CKRecordValue
        record["lastName"] = user.lastName as CKRecordValue
        record["email"] = user.email as CKRecordValue
        
        publicDatabase.save(record) { savedRecord, error in
            if let error = error {
                completion(.failure(error))
            } else {
                user.userID = savedRecord?.recordID
                self.users.append(user)
                completion(.success(savedRecord))
            }
        }
    }
    
    
    func fetchUsers() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "UserApp", predicate: predicate)
        
        print("in fetchusers")
        publicDatabase.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error fetching users: \(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self.users = results?.compactMap { record in
                        let user = UserApp(firstName: record["firstName"] as! String, lastName: record["lastName"] as! String, email: record["email"] as! String)
                        user.userID = record.recordID
                        
                        
                        if user.email == self.storedEmail //TODO: Logic to determine current logged-in user
                        {
                            
                            self.currentUser = user
//                            print(self.currentUser?.userID)
                            
                            
                        }
                        
                        return user
                    } ?? []
                }
            }
        }
    }
    
    
}

