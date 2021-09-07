//
//  ComposerServiceTests.swift
//  ComposersTests
//
//  Created by Enoch Chan on 4/25/21.
//

import XCTest
@testable import Composers

class ComposerServiceTests: XCTestCase {
    var systemUnderTest: ComposerService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.systemUnderTest = ComposerService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.systemUnderTest = nil
    }

    func testAPI_returnsSuccessfulResult() {
        // Given
        var composers: [Composer]!
        var error: Error?
        
        let promise = expectation(description: "Completion handler is invoked")
        
        // When
        self.systemUnderTest.getComposers(completion: { data, shouldntHappen in
            composers = data
            error = shouldntHappen
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertNotNil(composers)
        XCTAssertNil(error)
    }
}
