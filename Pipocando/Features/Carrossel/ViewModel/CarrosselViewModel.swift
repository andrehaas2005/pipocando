//
//  CarrosselViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 13/02/26.
//

import Foundation

class CarrosselViewModel: MovieViewModelProtocol {

  var movieService: any MovieServiceProtocol
  var screenState: Observable<MoviePosterState> = .init(.idle)

  init(movieService: any MovieServiceProtocol = MovieService()) {
    self.movieService = movieService
  }

  func fetchData() {
    screenState.value = .loading

    movieService.fetchNowPlayingMovies { [weak self] result in
      switch result {
      case .success(let movies):
        self?.screenState.value = .loaded(movies)
      case .failure(let error):
        self?.screenState.value = .error(AppError.map(error))
      }
    }
  }
}
