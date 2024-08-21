//
//  UserApp.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 20/08/24.
//

import Foundation
import CloudKit

class UserApp {
    var userID: CKRecord.ID?
    var firstName: String
    var lastName: String
    var email: String
    
    init(firstName: String, lastName : String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
