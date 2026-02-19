//
//  MovieViewModelProtocol.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//
 
protocol MovieViewModelProtocol {
  var movieService: MovieServiceProtocol {get set}
  var screenState: Observable<MoviePosterState> { get set }
  func fetchData()
}

enum MoviePosterState {
  case loading(isLoading: Bool)
  case success([Movie])
  case failure(String)
}
