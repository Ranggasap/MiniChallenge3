//
//  Report.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 20/08/24.
//

import Foundation
import CloudKit

class Report {
    var reportID: CKRecord.ID?
    var reportDate: Date
    var reportKronologi: String
    var location: CLLocation
    var userID: CKRecord.ID
    
    init(reportDate: Date, reportKronologi: String, location: CLLocation, userID: CKRecord.ID) {
        self.reportDate = reportDate
        self.reportKronologi = reportKronologi
        self.location = location
        self.userID = userID
    }
    
}
