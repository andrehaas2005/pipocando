//
//  SeriesRepositoryImpl.swift
//  Pipocando
//

import Foundation

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
