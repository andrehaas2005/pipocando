//
//  HomeFeedViewModelsTests.swift
//  PipocandoTests
//

import XCTest
@testable import Pipocando

@MainActor
final class HomeFeedViewModelsTests: XCTestCase {

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

  func testPosterViewModelEmitsLoadedStateOnSuccess() async {
    let spy = FetchNowPlayingUseCaseSpy()
    spy.result = .success([makeMovie(id: 101)])
    let sut = PosterViewModel(fetchNowPlayingMoviesUseCase: spy)

    sut.fetchData()
    await Task.yield()

    guard let state = sut.screenState.value else {
      return XCTFail("Expected a state value")
    }

    switch state {
    case .loaded(let movies):
      XCTAssertEqual(movies.first?.id, 101)
    default:
      XCTFail("Expected loaded state")
    }
  }

  func testCarrosselViewModelEmitsErrorStateOnFailure() async {
    let spy = FetchNowPlayingUseCaseSpy()
    spy.result = .failure(.network)
    let sut = CarrosselViewModel(fetchNowPlayingMoviesUseCase: spy)

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
