//
//  FetchMovieDetailsUseCase.swift
//  Pipocando
//

import Foundation

protocol FetchMovieDetailsUseCase {
  func execute(movieID: Int) async throws -> MovieDetails
}

final class DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {
  private let repository: any MovieDetailsRepository

  init(repository: any MovieDetailsRepository) {
    self.repository = repository
  }

  func execute(movieID: Int) async throws -> MovieDetails {
    try await repository.fetchMovieDetails(movieID)
  }
}
