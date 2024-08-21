//
//  ReportManager.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 20/08/24.
//

import Foundation
import CloudKit
import Combine
import CoreLocation

class ReportManager: CloudKitConnection, ObservableObject {
    @Published var reports: [Report] = []
    @Published var reportsNearby: [Report] = []
    private var geofencingManager = GeofencingManager()
    
    func createReport(report: Report, completion: @escaping (Result<CKRecord?, Error>) -> Void) {
        let record = CKRecord(recordType: "Report")
        record["reportDate"] = report.reportDate as CKRecordValue
        record["reportKronologi"] = report.reportKronologi as CKRecordValue
        record["location"] = report.location
        record["userID"] = CKRecord.Reference(recordID: report.userID, action: .none)
        
        
        publicDatabase.save(record) { savedRecord, error in
            if let error = error {
                completion(.failure(error))
            } else {
                report.reportID = savedRecord!.recordID
                self.reports.append(report)
                completion(.success(savedRecord))
            }
        }
    }
    
    func fetchReports() {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: "Report", predicate: predicate)
            
            publicDatabase.perform(query, inZoneWith: nil) { results, error in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Error fetching reports: \(error.localizedDescription)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.reports = results?.compactMap { record in
                            guard let reportDate = record["reportDate"] as? Date,
                                  let reportKronologi = record["reportKronologi"] as? String,
                                  let location = record["location"] as? CLLocation,
                                  let userIDRef = record["userID"] as? CKRecord.Reference else {
                                return nil
                            }
                            
                            let report = Report(reportDate: reportDate, reportKronologi: reportKronologi, location: location, userID: userIDRef.recordID)
                            report.reportID = record.recordID
                            return report
                        } ?? []
                    }
                }
            }
        }
    
    func fetchReportsNearUserLocation(userLocation: CLLocation) {
            // Define a circular region with a 1 km (1000 meters) radius
            let region = CLCircularRegion(center: userLocation.coordinate, radius: 1500, identifier: "NearbyRegion")
            
            // Perform a broad query to get reports (this won't filter by distance yet)
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: "Report", predicate: predicate)
        
            publicDatabase.perform(query, inZoneWith: nil) { results, error in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Error fetching reports: \(error.localizedDescription)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.reportsNearby.removeAll()
                       
                        // Filter the results manually to see if they are within the 1 km region
                        self.reportsNearby = results?.compactMap { record in
                            guard let reportDate = record["reportDate"] as? Date,
                                  let reportKronologi = record["reportKronologi"] as? String,
                                  let location = record["location"] as? CLLocation,
                                  let userIDRef = record["userID"] as? CKRecord.Reference else {
                                return nil
                            }
                            
                            
                            // Check if the report's location is within the defined region
                            if region.contains(location.coordinate) {
                                let report = Report(reportDate: reportDate, reportKronologi: reportKronologi, location: location, userID: userIDRef.recordID)
                                report.reportID = record.recordID
                                return report
                            }
                            
                            return nil
                        } ?? []
                        
                        self.geofencingManager.startMonitoringForReports(self.reportsNearby)
                    }
                }
            }
        }
    
    
    
    
    
    func deleteReport(report: Report, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let recordID = report.reportID else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record ID"])))
            return
        }
        
        publicDatabase.delete(withRecordID: recordID) { deletedRecordID, error in
            if let error = error {
                completion(.failure(error))
            } else {
                DispatchQueue.main.async {
                    self.reports.removeAll { $0.reportID == recordID }
                }
                completion(.success(()))
            }
        }
    }
    

    
}



