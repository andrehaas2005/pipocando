//
//  CalendarViewModelTests.swift
//  PipocandoTests
//

import XCTest
@testable import Pipocando

@MainActor
final class CalendarViewModelTests: XCTestCase {

  private final class CalendarRoutingSpy: CalendarRouting {
    var didShowSerie = false

    func showSerieDetails(_ serie: Serie) {
      didShowSerie = true
    }
  }

  private final class SerieServiceSpy: SerieServiceProtocol {
    var result: Result<[Serie], Error> = .success([])

    func fetchSerieTopReted(completion: @escaping (Result<[Serie], any Error>) -> Void) {
      completion(result)
    }

    func fetchSerieOnTheAir(completion: @escaping (Result<[Serie], any Error>) -> Void) {
      completion(result)
    }

    func fetchSeriePopular(completion: @escaping (Result<[Serie], any Error>) -> Void) {
      completion(result)
    }

    func fetchSerieAiringToday(completion: @escaping (Result<[Serie], any Error>) -> Void) {
      completion(result)
    }

    func fetchSeriesAiring(on date: String, completion: @escaping (Result<[Serie], any Error>) -> Void) {
      completion(result)
    }

    func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], Error>) -> Void) {
      completion(result)
    }

    func fetchSerieDetails(completion: @escaping (Result<[Serie], Error>) -> Void) {
      completion(result)
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
    let service = SerieServiceSpy()
    service.result = .success([makeSerie(id: 7)])

    let sut = CalendarViewModel(coordinator: routing, serieService: service)
    sut.didSelectDate(at: 2)
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
    let service = SerieServiceSpy()
    service.result = .failure(AppError.network)

    let sut = CalendarViewModel(coordinator: routing, serieService: service)
    sut.didSelectDate(at: 2)
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
