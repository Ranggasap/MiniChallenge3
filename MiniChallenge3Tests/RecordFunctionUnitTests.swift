//
//  RecordFunctionUnitTests.swift
//  MiniChallenge3Tests
//
//  Created by Rangga Saputra on 20/08/24.
//

import XCTest
@testable import MiniChallenge3

final class RecordFunctionUnitTests: XCTestCase {

    func successFetchRecording(){
        let recordFunction = recordFunction()
        
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dummyFileURL = documentPath.appendingPathComponent("test.m4a")
        
        let dummyData = "Dummy data".data(using: .utf8)
        fileManager.createFile(atPath: dummyFileURL.path, contents: dummyData, attributes: nil)
        
        let fetchedRecordings = recordFunction.fetchRecordings()
        
        XCTAssertEqual(fetchedRecordings.count, 1)
        XCTAssertEqual(fetchedRecordings.first, dummyFileURL)
        
        try? fileManager.removeItem(at: dummyFileURL)
    }
    
    func testFetchRecordings_noFiles() {
        let recordFunction = recordFunction()
        
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let files = try? fileManager.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil, options: [])
        files?.forEach { file in
            if file.pathExtension == "m4a" {
                try? fileManager.removeItem(at: file)
            }
        }
        
        let fetchedRecordings = recordFunction.fetchRecordings()
        
        XCTAssertTrue(fetchedRecordings.isEmpty)
    }
    
}
