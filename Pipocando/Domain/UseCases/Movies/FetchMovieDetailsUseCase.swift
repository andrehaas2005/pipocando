//
//  FetchMovieDetailsUseCase.swift
//  Pipocando
//

import Foundation

protocol FetchMovieDetailsUseCase {
  func execute(movieID: Int, completion: @escaping (Result<MovieDetails, AppError>) -> Void)
}

final class DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {
  private let repository: any MovieDetailsRepository

  init(repository: any MovieDetailsRepository) {
    self.repository = repository
  }

  func execute(movieID: Int, completion: @escaping (Result<MovieDetails, AppError>) -> Void) {
    repository.fetchMovieDetails(movieID, completion: completion)
  }
}
