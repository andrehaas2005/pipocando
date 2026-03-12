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

@MainActor
class HomeViewModel {
  private let fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase
  weak var coordinator: (any HomeRouting)?
  var screenState: Observable<MoviePosterState> = .init(.idle)

  init(fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase) {
    self.fetchNowPlayingMoviesUseCase = fetchNowPlayingMoviesUseCase
  }

  func fetchData() {
    screenState.value = .loading

    fetchNowPlayingMoviesUseCase.execute { [weak self] result in
      switch result {
      case .success(let movies):
        self?.screenState.value = .loaded(movies)
      case .failure(let error):
        self?.screenState.value = .error(error)
      }
    }
  }
}
