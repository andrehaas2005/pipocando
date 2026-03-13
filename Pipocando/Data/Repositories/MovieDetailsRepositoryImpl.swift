//
//  MovieDetailsRepositoryImpl.swift
//  Pipocando
//

import Foundation

final class MovieDetailsRepositoryImpl: MovieDetailsRepository {
  private let movieService: any MovieServiceProtocol

  init(movieService: any MovieServiceProtocol) {
    self.movieService = movieService
  }

  func fetchMovieDetails(_ movieID: Int, completion: @escaping (Result<MovieDetails, AppError>) -> Void) {
    movieService.fetchMovieDetails(movieID) { result in
      switch result {
      case .success(let details):
        completion(.success(details))
      case .failure(let error):
        completion(.failure(AppError.map(error)))
      }
    }
  }
}
