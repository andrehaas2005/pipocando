//
//  CarrosselViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 13/02/26.
//

import Foundation


class CarrosselViewModel: MovieViewModelProtocol {
  
  var movieService: any MovieServiceProtocol
  var screenState: Observable<MoviePosterState> = Observable(.loading(isLoading: false))
  
  init(movieService: any MovieServiceProtocol = MovieService()) {
    self.movieService = movieService
  }
  
  func fetchData() {
    movieService.fetchNowPlayingMovies { [weak self] result in
      switch result {
      case .success(let movies):
        self?.screenState.value = .success(movies)
      case .failure(let error):
        self?.screenState.value = .failure(error.localizedDescription)
      }
    }
  }
  
  
  
}
