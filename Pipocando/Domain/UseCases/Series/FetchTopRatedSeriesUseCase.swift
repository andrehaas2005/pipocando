//
//  FetchTopRatedSeriesUseCase.swift
//  Pipocando
//

import Foundation

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
