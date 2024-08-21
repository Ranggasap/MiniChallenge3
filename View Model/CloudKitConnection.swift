//
//  CloudKitConnection.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 20/08/24.
//

//TODO: belum masukin container identifier
import Foundation
import CloudKit

class CloudKitConnection {
    let container: CKContainer
    let publicDatabase: CKDatabase
    
    init(container: CKContainer = CKContainer.default()) {
        self.container = container
        self.publicDatabase = container.publicCloudDatabase
    }
    
    
}
