//
//  AppDependencyContainer.swift
//  Pipocando
//

import Foundation

protocol AppDependencies {
  var movieService: any MovieServiceProtocol { get }
  var serieService: any SerieServiceProtocol { get }
}

final class AppDependencyContainer: AppDependencies {
  let movieService: any MovieServiceProtocol
  let serieService: any SerieServiceProtocol

  init(
    movieService: any MovieServiceProtocol = MovieService.shared,
    serieService: any SerieServiceProtocol = SerieService.shared
  ) {
    self.movieService = movieService
    self.serieService = serieService
  }
}
