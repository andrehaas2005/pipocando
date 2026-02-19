//
//  RouterMovie.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//


public enum RouterMovie {
  case topRated
  case nowPlaying
  case popular
  case upcoming
  
  func path() -> String {
    switch self {
    case .topRated:
      Configuration.Endpoints.Movies.topRated
    case .nowPlaying:
      Configuration.Endpoints.Movies.nowPlaying
    case .popular:
      Configuration.Endpoints.Movies.popular
    case .upcoming:
      Configuration.Endpoints.Movies.upcoming
    }
  }
}

