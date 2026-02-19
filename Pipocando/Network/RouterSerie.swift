//
//  RouterSerie.swift
//  Pipocando
//
//  Created by Andre  Haas on 14/02/26.
//


public enum RouterSerie {
  case airingToday
  case onTheAir
  case popular
  case topRated
  
  func path() -> String {
    switch self {
    case .airingToday:
      Configuration.Endpoints.Series.airingToday
    case .onTheAir:
      Configuration.Endpoints.Series.onTheAir
    case .popular:
      Configuration.Endpoints.Series.popular
    case .topRated:
      Configuration.Endpoints.Series.topRated
    }
  }
}