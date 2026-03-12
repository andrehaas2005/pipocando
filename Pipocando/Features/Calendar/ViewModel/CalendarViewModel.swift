//
//  CalendarViewModel.swift
//  AmorPorFilmesSeries
//

import Foundation

protocol CalendarRouting: AnyObject {}

enum SerieState {
  case idle
  case loading
  case loaded([Serie])
  case error(AppError)
}

protocol SeriesRepository {
  func fetchTopRatedSeries(completion: @escaping (Result<[Serie], AppError>) -> Void)
}

final class SeriesRepositoryImpl: SeriesRepository {
  private let serieService: any SerieServiceProtocol

  init(serieService: any SerieServiceProtocol) {
    self.serieService = serieService
  }

  func fetchTopRatedSeries(completion: @escaping (Result<[Serie], AppError>) -> Void) {
    serieService.fetchSerieTopReted { result in
      switch result {
      case .success(let series):
        completion(.success(series))
      case .failure(let error):
        completion(.failure(AppError.map(error)))
      }
    }
  }
}

protocol FetchTopRatedSeriesUseCase {
  func execute(completion: @escaping (Result<[Serie], AppError>) -> Void)
}

final class DefaultFetchTopRatedSeriesUseCase: FetchTopRatedSeriesUseCase {
  private let repository: any SeriesRepository

  init(repository: any SeriesRepository) {
    self.repository = repository
  }

  func execute(completion: @escaping (Result<[Serie], AppError>) -> Void) {
    repository.fetchTopRatedSeries(completion: completion)
  }
}

@MainActor
class CalendarViewModel {
  weak var coordinator: (any CalendarRouting)?

  // swiftlint:disable large_tuple
  var dates: Observable<[(day: String, date: String, isSelected: Bool)]> = Observable([])
  var releases: Observable<SerieState> = Observable(.idle)
  private let fetchTopRatedSeriesUseCase: any FetchTopRatedSeriesUseCase

  init(coordinator: any CalendarRouting, fetchTopRatedSeriesUseCase: any FetchTopRatedSeriesUseCase) {
    self.coordinator = coordinator
    self.fetchTopRatedSeriesUseCase = fetchTopRatedSeriesUseCase
    fetchData()
  }

  func fetchData() {
    dates.value = generateWeekDates()
    releases.value = .loading
    fetchTopRatedSeriesUseCase.execute { [weak self] result in
      switch result {
      case .success(let series):
        self?.releases.value = .loaded(series)
      case .failure(let error):
        self?.releases.value = .error(error)
      }
    }
  }

  func generateWeekDates() -> [(day: String, date: String, isSelected: Bool)] {

    let calendar = Calendar.current
    let today = Date()

    // Formatter para dia da semana (SEG, TER...)
    let dayFormatter = DateFormatter()
    dayFormatter.locale = Locale(identifier: "pt_BR")
    dayFormatter.dateFormat = "EEE"

    // Formatter para dia numérico (18, 19...)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "pt_BR")
    dateFormatter.dateFormat = "dd"

    var result: [(day: String, date: String, isSelected: Bool)] = []

    for offset in -2...4 { // 2 dias antes + hoje + 4 depois = 7 dias

      if let date = calendar.date(byAdding: .day, value: offset, to: today) {

        let dayString = dayFormatter.string(from: date)
          .uppercased()

        let dateString = dateFormatter.string(from: date)

        let isSelected = calendar.isDate(date, inSameDayAs: today)

        result.append((day: dayString,
                       date: dateString,
                       isSelected: isSelected))
      }
    }
    return result
  }
}
