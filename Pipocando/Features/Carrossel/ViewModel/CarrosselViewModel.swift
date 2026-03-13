//
//  CarrosselViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 13/02/26.
//

import Foundation

@MainActor
class CarrosselViewModel: MovieViewModelProtocol {

  private let fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase
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
