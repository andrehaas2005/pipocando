//
//  HomeViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import Foundation

class HomeViewModel {
  var service: MovieServiceProtocol
  weak var coordinator: HomeCoordinator?
  var screenState: Observable<MoviePosterState> = .init(.loading(isLoading: false))
  
  init(service: MovieServiceProtocol = MovieService()) {
    self.service = service
  }
  
  func fetchData() {
    service.fetchNowPlayingMovies { [weak self] result in
      switch result {
      case .success(let movies):
        self?.screenState.value = .success(movies)
      case .failure(let error):
        self?.screenState.value = .failure(error.localizedDescription)
      }
    }
  }
}
