//
//  MovieViewModelProtocol.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//

protocol MovieViewModelProtocol {
  var screenState: Observable<MoviePosterState> { get set }
  func fetchData()
}

enum MoviePosterState {
  case idle
  case loading
  case loaded([Movie])
  case error(AppError)
}
