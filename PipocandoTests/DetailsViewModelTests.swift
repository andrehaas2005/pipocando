//
//  DetailsViewModelTests.swift
//  PipocandoTests
//

import XCTest
@testable import Pipocando

@MainActor
final class DetailsViewModelTests: XCTestCase {

  private final class FetchMovieDetailsUseCaseSpy: FetchMovieDetailsUseCase {
    var result: Result<MovieDetails, AppError> = .failure(.unknown(message: "not-set"))

    func execute(movieID: Int) async throws -> MovieDetails {
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

  private func makeMovieDetails(id: Int = 1) throws -> MovieDetails {
    let json = """
    {
      "adult": false,
      "backdrop_path": "/backdrop.jpg",
      "belongs_to_collection": null,
      "budget": 0,
      "genres": [{"id": 18, "name": "Drama"}],
      "homepage": "",
      "id": \(id),
      "imdb_id": "tt0000001",
      "origin_country": ["BR"],
      "original_language": "pt",
      "original_title": "Filme",
      "overview": "Resumo",
      "popularity": 10.0,
      "poster_path": "/poster.jpg",
      "production_companies": [],
      "production_countries": [],
      "release_date": "2024-01-01",
      "revenue": 0,
      "runtime": 125,
      "spoken_languages": [],
      "status": "Released",
      "tagline": "",
      "title": "Filme",
      "video": false,
      "vote_average": 7.5,
      "vote_count": 100,
      "videos": null,
      "credits": null
    }
    """

    return try JSONDecoder().decode(MovieDetails.self, from: Data(json.utf8))
  }

  func testDetailsViewModelEmitsLoadedStateOnSuccess() async throws {
    let spy = FetchMovieDetailsUseCaseSpy()
    spy.result = .success(try makeMovieDetails(id: 321))

    let sut = DetailsViewModel(detailType: .movie(makeMovie(id: 321)), fetchMovieDetailsUseCase: spy)

    await Task.yield()

    guard let state = sut.screenState.value else {
      return XCTFail("Expected a state value")
    }

    switch state {
    case .loaded(let details):
      XCTAssertEqual(details.id, 321)
    default:
      XCTFail("Expected loaded state")
    }
  }

  func testDetailsViewModelEmitsErrorStateOnFailure() async {
    let spy = FetchMovieDetailsUseCaseSpy()
    spy.result = .failure(.network)

    let sut = DetailsViewModel(detailType: .movie(makeMovie(id: 99)), fetchMovieDetailsUseCase: spy)

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
