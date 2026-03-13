//
//  SeriesRepository.swift
//  Pipocando
//

import Foundation

protocol SeriesRepository {
  func fetchTopRatedSeries() async throws -> [Serie]
}
