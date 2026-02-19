//
//  Configuration_Tests.swift
//  PipocandoTests
//
//  Created by Andre  Haas on 12/02/26.
//

import XCTest
@testable import Pipocando

final class Configuration_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func returnEnumString() throws {
     XCTAssertNotNil(Configuration.apiKey)
      XCTAssertNotNil(Configuration.baseAPIURL)
      XCTAssertNotNil(Configuration.imageBaseURL) 
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
