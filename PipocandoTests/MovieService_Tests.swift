import XCTest
@testable import Pipocando

final class MovieService_Tests: XCTestCase {

  private final class NetworkSpy: MovieRequesting {
    enum SpyError: Error { case invalidCast, forcedFailure }

    var lastRequestedPath: RouterMovie?
    var requestedPaths: [RouterMovie] = []
    var result: Result<Any, Error> = .failure(SpyError.forcedFailure)

    func request<T>(_ request: APIMovieRequest) async throws -> T where T : Decodable {
      lastRequestedPath = request.path
      requestedPaths.append(request.path)
      switch result {
      case .success(let value):
        guard let typed = value as? T else { throw SpyError.invalidCast }
        return typed
      case .failure(let error):
        throw error
      }
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

  func testFetchPopularMoviesRequestsPopularPathAndReturnsMovies() {
    let spy = NetworkSpy()
    let expectedMovies = [makeMovie()]
    spy.result = .success(Cover(page: 1, results: expectedMovies, totalPages: 1, totalResults: 1))
    let sut = MovieService(service: spy)

    let exp = expectation(description: "popular completion")
    sut.fetchPopularMovies { result in
      switch result {
      case .success(let movies):
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies.first?.id, expectedMovies.first?.id)
      case .failure(let error):
        XCTFail("Expected success, got error: \(error)")
      }
      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(spy.lastRequestedPath, .popular)
  }

  func testFetchTopRatedAndUpcomingRequestsExpectedPaths() {
    let spy = NetworkSpy()
    spy.result = .success(Cover(page: 1, results: [makeMovie()], totalPages: 1, totalResults: 1))
    let sut = MovieService(service: spy)

    let topRated = expectation(description: "top rated completion")
    sut.fetchTopRatedMovies { _ in topRated.fulfill() }

    let upcoming = expectation(description: "upcoming completion")
    sut.fetchUpcomingMovies { _ in upcoming.fulfill() }

    wait(for: [topRated, upcoming], timeout: 1.0)
    XCTAssertEqual(spy.requestedPaths, [.topRated, .upcoming])
  }

  func testFetchNowPlayingPropagatesFailure() {
    let spy = NetworkSpy()
    spy.result = .failure(NetworkSpy.SpyError.forcedFailure)
    let sut = MovieService(service: spy)

    let exp = expectation(description: "now playing completion")
    sut.fetchNowPlayingMovies { result in
      switch result {
      case .success:
        XCTFail("Expected failure")
      case .failure(let error):
        XCTAssertTrue(error is NetworkSpy.SpyError)
      }
      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(spy.lastRequestedPath, .nowPlaying)
  }
}
