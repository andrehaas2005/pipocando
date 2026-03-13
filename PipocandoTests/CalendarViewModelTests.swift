//
//  CalendarViewModelTests.swift
//  PipocandoTests
//

import XCTest
@testable import Pipocando

@MainActor
final class CalendarViewModelTests: XCTestCase {

  private final class CalendarRoutingSpy: CalendarRouting {}

  private final class FetchTopRatedSeriesUseCaseSpy: FetchTopRatedSeriesUseCase {
    var result: Result<[Serie], AppError> = .success([])

    func execute() async throws -> [Serie] {
      try result.get()
    }
  }

  private func makeSerie(id: Int = 1) -> Serie {
    Serie(
      adult: false,
      backdropPath: "/backdrop.jpg",
      firstAirDate: "2024-01-01",
      genreIDS: [1],
      id: id,
      originCountry: ["BR"],
      name: "Serie \(id)",
      originalLanguage: "pt",
      originalName: "Original Serie \(id)",
      overview: "Overview",
      popularity: 10.0,
      posterPath: "/poster.jpg",
      voteAverage: 7.5,
      voteCount: 100
    )
  }

  func testCalendarViewModelEmitsLoadedOnSuccess() async {
    let routing = CalendarRoutingSpy()
    let useCase = FetchTopRatedSeriesUseCaseSpy()
    useCase.result = .success([makeSerie(id: 7)])

    let sut = CalendarViewModel(coordinator: routing, fetchTopRatedSeriesUseCase: useCase)
    await Task.yield()

    guard let state = sut.releases.value else {
      return XCTFail("Expected state")
    }

    switch state {
    case .loaded(let series):
      XCTAssertEqual(series.first?.id, 7)
    default:
      XCTFail("Expected loaded state")
    }
  }

  func testCalendarViewModelEmitsErrorOnFailure() async {
    let routing = CalendarRoutingSpy()
    let useCase = FetchTopRatedSeriesUseCaseSpy()
    useCase.result = .failure(.network)

    let sut = CalendarViewModel(coordinator: routing, fetchTopRatedSeriesUseCase: useCase)
    await Task.yield()

    guard let state = sut.releases.value else {
      return XCTFail("Expected state")
    }

    switch state {
    case .error(let error):
      XCTAssertEqual(error.userMessage, AppError.network.userMessage)
    default:
      XCTFail("Expected error state")
    }
  }
}
