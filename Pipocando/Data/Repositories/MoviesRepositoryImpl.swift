//
//  MoviesRepositoryImpl.swift
//  Pipocando
//

import Foundation

final class MoviesRepositoryImpl: MoviesRepository {
  private let movieService: any MovieServiceProtocol

  init(movieService: any MovieServiceProtocol) {
    self.movieService = movieService
  }

  func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], AppError>) -> Void) {
    movieService.fetchNowPlayingMovies { result in
      switch result {
      case .success(let movies):
        completion(.success(movies))
      case .failure(let error):
        completion(.failure(AppError.map(error)))
      }
    }
  }
}
