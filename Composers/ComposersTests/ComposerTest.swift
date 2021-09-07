//
//  ComposerTest.swift
//  ComposersTests
//
//  Created by Enoch Chan on 4/25/21.
//

import XCTest // XCTest is a library that helps test assertions in iOS
@testable import Composers // import classes from Composers to test them

class ComposerTest: XCTestCase {


    func testComposerDebugDescription() {
        // Given: environment that is given
        let subjectUnderTest = Composer(named: "Jean Sibelius", period: "Romantic", country: "Finland", imageUrl: "https://serenademagazine.com/wp-content/uploads/2017/12/Jean_Sibelius_1913-1-e1515262530282.jpg")
        
        // When: action to simulate in the test
        let actualValue = subjectUnderTest.debugDescription
        
        // Then: desired/expected behavior
        let expectedValue = "Composer(name: Jean Sibelius, period: Romantic)"
        
        XCTAssertEqual(actualValue, expectedValue)
    }

}
