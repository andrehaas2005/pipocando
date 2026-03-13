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

  func fetchNowPlayingMovies() async throws -> [Movie] {
    try await withCheckedThrowingContinuation { continuation in
      movieService.fetchNowPlayingMovies { result in
        switch result {
        case .success(let movies):
          continuation.resume(returning: movies)
        case .failure(let error):
          continuation.resume(throwing: AppError.map(error))
        }
      }
    }
  }
}
