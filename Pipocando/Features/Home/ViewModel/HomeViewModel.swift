//
//  HomeViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import Foundation

protocol HomeRouting: AnyObject {
  func showMovieDetails(_ movie: Movie)
}

protocol MoviesRepository {
  func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], AppError>) -> Void)
}

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

class HomeViewModel {
  private let fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase
  weak var coordinator: (any HomeRouting)?
  var screenState: Observable<MoviePosterState> = .init(.loading(isLoading: false))

  init(fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase) {
    self.fetchNowPlayingMoviesUseCase = fetchNowPlayingMoviesUseCase
  }

  func fetchData() {
    screenState.value = .loading(isLoading: true)

    fetchNowPlayingMoviesUseCase.execute { [weak self] result in
      switch result {
      case .success(let movies):
        self?.screenState.value = .success(movies)
      case .failure(let error):
        self?.screenState.value = .failure(error.userMessage)
      }
    }
  }
}
