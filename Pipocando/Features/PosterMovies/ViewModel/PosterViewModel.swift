//
//  PosterViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//
import Foundation

class PosterViewModel: MovieViewModelProtocol {
  
  var screenState: Observable<MoviePosterState> = .init(.loading(isLoading: false))
  
  var movieService: (any MovieServiceProtocol)
  
  init(movieService: MovieServiceProtocol = MovieService()) {
    self.movieService = movieService
  }
  
  func fetchData() {
    movieService.fetchNowPlayingMovies { result in
      switch result {
      case .success(let movies):
        self.screenState.value = .success(movies)
      case .failure(let error):
        self.screenState.value = .failure(error.localizedDescription)
      }
    }
  }
}
