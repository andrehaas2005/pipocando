//
//  FetchNowPlayingMoviesUseCase.swift
//  Pipocando
//

import Foundation

protocol FetchNowPlayingMoviesUseCase {
  func execute() async throws -> [Movie]
}

final class DefaultFetchNowPlayingMoviesUseCase: FetchNowPlayingMoviesUseCase {
  private let repository: any MoviesRepository

  init(repository: any MoviesRepository) {
    self.repository = repository
  }

  func execute() async throws -> [Movie] {
    try await repository.fetchNowPlayingMovies()
  }
}
