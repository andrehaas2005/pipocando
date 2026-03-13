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

  func fetchMovieDetails(_ movieID: Int) async throws -> MovieDetails {
    try await withCheckedThrowingContinuation { continuation in
      movieService.fetchMovieDetails(movieID) { result in
        switch result {
        case .success(let details):
          continuation.resume(returning: details)
        case .failure(let error):
          continuation.resume(throwing: AppError.map(error))
        }
      }
    }
  }
}
