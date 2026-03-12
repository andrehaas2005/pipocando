//
//  AppDependencyContainer.swift
//  Pipocando
//

import Foundation

protocol AppDependencies {
  var movieService: any MovieServiceProtocol { get }
  var serieService: any SerieServiceProtocol { get }

  func makeFetchNowPlayingMoviesUseCase() -> any FetchNowPlayingMoviesUseCase
  func makeFetchTopRatedSeriesUseCase() -> any FetchTopRatedSeriesUseCase
  func makeFetchMovieDetailsUseCase() -> any FetchMovieDetailsUseCase
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

  func makeFetchNowPlayingMoviesUseCase() -> any FetchNowPlayingMoviesUseCase {
    let repository = MoviesRepositoryImpl(movieService: movieService)
    return DefaultFetchNowPlayingMoviesUseCase(repository: repository)
  }

  func makeFetchTopRatedSeriesUseCase() -> any FetchTopRatedSeriesUseCase {
    let repository = SeriesRepositoryImpl(serieService: serieService)
    return DefaultFetchTopRatedSeriesUseCase(repository: repository)
  }

  func makeFetchMovieDetailsUseCase() -> any FetchMovieDetailsUseCase {
    let repository = MovieDetailsRepositoryImpl(movieService: movieService)
    return DefaultFetchMovieDetailsUseCase(repository: repository)
  }

}
