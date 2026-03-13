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
    movieService: any MovieServiceProtocol,
    serieService: any SerieServiceProtocol
  ) {
    self.movieService = movieService
    self.serieService = serieService
  }

  func makeFetchNowPlayingMoviesUseCase() -> any FetchNowPlayingMoviesUseCase {
    let remoteDataSource = DefaultMovieRemoteDataSource(movieService: movieService)
    let repository = MoviesRepositoryImpl(remoteDataSource: remoteDataSource)
    return DefaultFetchNowPlayingMoviesUseCase(repository: repository)
  }

  func makeFetchTopRatedSeriesUseCase() -> any FetchTopRatedSeriesUseCase {
    let remoteDataSource = DefaultSerieRemoteDataSource(serieService: serieService)
    let repository = SeriesRepositoryImpl(remoteDataSource: remoteDataSource)
    return DefaultFetchTopRatedSeriesUseCase(repository: repository)
  }

  func makeFetchMovieDetailsUseCase() -> any FetchMovieDetailsUseCase {
    let remoteDataSource = DefaultMovieRemoteDataSource(movieService: movieService)
    let repository = MovieDetailsRepositoryImpl(remoteDataSource: remoteDataSource)
    return DefaultFetchMovieDetailsUseCase(repository: repository)
  }

}
