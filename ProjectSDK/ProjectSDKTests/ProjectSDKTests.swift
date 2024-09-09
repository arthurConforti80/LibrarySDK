//
//  ProjectSDKTests.swift
//  ProjectSDKTests
//
//  Created by Arthur Conforti on 07/09/2024.
//

import XCTest
import LibrarySDK

class LoggingSDKTests: XCTestCase {
    
    /**
     Test to ensure a string is successfully sent to the server.
     This test simulates sending a valid string to the backend. It expects the string to be successfully processed, fulfilling the expectation.
     */
    func testSendString_Success() {
        let expectation = self.expectation(description: "String successfully sent")
        
        LibraryService.shared.sendString("Test for successful string sending") { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to send string: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /**
     Test for handling an empty string input.
     This test ensures that if the user attempts to send an empty string, the SDK correctly returns an error.
     The expected error code is -2, and the error domain is "Invalid response".
     */
    func testSendString_EmptyString() {
        let expectation = self.expectation(description: "Empty string error captured")
        
        LibraryService.shared.sendString("") { result in
            switch result {
            case .success:
                XCTFail("Sending an empty string should not succeed")
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "Empty String")
                XCTAssertEqual(error.code, -3)
                XCTAssertEqual(error.localizedDescription, "String cannot be empty.")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
