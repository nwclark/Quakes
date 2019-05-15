//
//  UTQuakeRequester.swift
//  QuakesTests
//
//  Created by Nathan Clark on 5/15/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//

import XCTest
@testable import Quakes

class UTQuakeRequester: XCTestCase {

    struct Default {
        static let timeout: TimeInterval = 10.0
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetLastDaysQuakes() {
        let expectation = XCTestExpectation(description: #function)

        let quakeRequester = QuakeRequester()
        quakeRequester.getLastDaysEvents {
            response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Default.timeout )
    }
}
