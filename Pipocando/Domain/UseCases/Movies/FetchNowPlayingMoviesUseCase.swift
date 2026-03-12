//
//  FetchNowPlayingMoviesUseCase.swift
//  Pipocando
//

import Foundation

protocol FetchNowPlayingMoviesUseCase {
  func execute(completion: @escaping (Result<[Movie], AppError>) -> Void)
}

final class DefaultFetchNowPlayingMoviesUseCase: FetchNowPlayingMoviesUseCase {
  private let repository: any MoviesRepository

  init(repository: any MoviesRepository) {
    self.repository = repository
  }

  func execute(completion: @escaping (Result<[Movie], AppError>) -> Void) {
    repository.fetchNowPlayingMovies(completion: completion)
  }
}
