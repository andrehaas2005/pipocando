//
//  MoviesRepository.swift
//  Pipocando
//

import Foundation

protocol MoviesRepository {
  func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], AppError>) -> Void)
}
