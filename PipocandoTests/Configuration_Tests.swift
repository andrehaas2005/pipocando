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
        setenv("BASE_URL", "https://example.base.url", 1)
        setenv("API_KEY", "test_api_key", 1)
        setenv("IMAGE_BASE_URL", "https://example.image.url", 1)
    }

    override func tearDownWithError() throws {
        unsetenv("BASE_URL")
        unsetenv("API_KEY")
        unsetenv("IMAGE_BASE_URL")
    }

    func testEnvironmentFallbackValuesAreAvailable() throws {
        XCTAssertNotNil(Configuration.apiKey)
        XCTAssertNotNil(Configuration.baseAPIURL)
        XCTAssertNotNil(Configuration.imageBaseURL)
        XCTAssertEqual(Configuration.apiKey, "test_api_key")
        XCTAssertEqual(Configuration.baseAPIURL, "https://example.base.url")
        XCTAssertEqual(Configuration.imageBaseURL, "https://example.image.url")
    }

    func testGenresEndpointIsNotEmpty() {
        XCTAssertFalse(Configuration.Endpoints.genres.isEmpty)
        XCTAssertEqual(Configuration.Endpoints.genres, "genre/movie/list")
    }
}
