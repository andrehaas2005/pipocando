//
//  PipocandoTests.swift
//  PipocandoTests
//
//  Created by Andre  Haas on 11/02/26.
//

import XCTest
import Alamofire
@testable import Pipocando

@MainActor
final class PipocandoTests: XCTestCase {

  private struct DummyError: Error {}

  private final class FetchNowPlayingUseCaseSpy: FetchNowPlayingMoviesUseCase {
    var result: Result<[Movie], AppError> = .success([])

    func execute() async throws -> [Movie] {
      try result.get()
    }
  }

  private func makeMovie(id: Int = 1) -> Movie {
    Movie(
      adult: false,
      backdropPath: "/backdrop.jpg",
      genreIDS: [1, 2],
      id: id,
      originalLanguage: "pt",
      originalTitle: "Título",
      overview: "Resumo",
      popularity: 12.3,
      posterPath: "/poster.jpg",
      releaseDate: "2024-01-01",
      title: "Filme",
      video: false,
      voteAverage: 8.0,
      voteCount: 100
    )
  }

  func testAppErrorMapsNetworkMovieErrorsToDomain() {
    XCTAssertEqual(AppError.map(NetworkMovieError.networkError).userMessage,
                   AppError.network.userMessage)
    XCTAssertEqual(AppError.map(NetworkMovieError.notfoundApiKey).userMessage,
                   AppError.invalidConfiguration.userMessage)
    XCTAssertEqual(AppError.map(NetworkMovieError.invalidURL).userMessage,
                   AppError.invalidResponse.userMessage)
  }

  func testAppErrorMapsUnknownErrorToUnknownMessage() {
    let mapped = AppError.map(DummyError())

    switch mapped {
    case .unknown:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected unknown AppError")
    }
  }

  func testAppErrorMapsAFErrorSessionTaskFailedToNetwork() {
    let afError = AFError.sessionTaskFailed(error: URLError(.notConnectedToInternet))

    XCTAssertEqual(AppError.map(afError).userMessage, AppError.network.userMessage)
  }

  func testAppErrorMapsAFErrorValidationFailedToInvalidResponse() {
    let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500))

    XCTAssertEqual(AppError.map(afError).userMessage, AppError.invalidResponse.userMessage)
  }

  func testHomeViewModelEmitsLoadedStateOnUseCaseSuccess() async {
    let spy = FetchNowPlayingUseCaseSpy()
    spy.result = .success([makeMovie(id: 99)])
    let sut = HomeViewModel(fetchNowPlayingMoviesUseCase: spy)

    sut.fetchData()
    await Task.yield()

    guard let state = sut.screenState.value else {
      return XCTFail("Expected a state value")
    }

    switch state {
    case .loaded(let movies):
      XCTAssertEqual(movies.count, 1)
      XCTAssertEqual(movies.first?.id, 99)
    default:
      XCTFail("Expected loaded state")
    }
  }

  func testHomeViewModelEmitsErrorStateOnUseCaseFailure() async {
    let spy = FetchNowPlayingUseCaseSpy()
    spy.result = .failure(.network)
    let sut = HomeViewModel(fetchNowPlayingMoviesUseCase: spy)

    sut.fetchData()
    await Task.yield()

    guard let state = sut.screenState.value else {
      return XCTFail("Expected a state value")
    }

    switch state {
    case .error(let error):
      XCTAssertEqual(error.userMessage, AppError.network.userMessage)
    default:
      XCTFail("Expected error state")
    }
  }
}
