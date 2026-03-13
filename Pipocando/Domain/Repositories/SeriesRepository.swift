//
//  SeriesRepository.swift
//  Pipocando
//

import Foundation

protocol SeriesRepository {
  func fetchTopRatedSeries(completion: @escaping (Result<[Serie], AppError>) -> Void)
}
