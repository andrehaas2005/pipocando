//
//  FetchTopRatedSeriesUseCase.swift
//  Pipocando
//

import Foundation

protocol FetchTopRatedSeriesUseCase {
  func execute() async throws -> [Serie]
}

final class DefaultFetchTopRatedSeriesUseCase: FetchTopRatedSeriesUseCase {
  private let repository: any SeriesRepository

  init(repository: any SeriesRepository) {
    self.repository = repository
  }

  func execute() async throws -> [Serie] {
    try await repository.fetchTopRatedSeries()
  }
}
