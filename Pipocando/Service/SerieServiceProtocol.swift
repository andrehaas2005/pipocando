//
//  SerieServiceProtocol.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//

protocol SerieServiceProtocol {
  func fetchSerieTopReted(completion: @escaping (Result<[Serie], any Error>) -> Void)
  func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], Error>) -> Void)
}
