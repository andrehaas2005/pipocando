//
//  PosterViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//
import Foundation

@MainActor
class PosterViewModel: MovieViewModelProtocol {

  var screenState: Observable<MoviePosterState> = .init(.idle)
  private let fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase

  init(fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase) {
    self.fetchNowPlayingMoviesUseCase = fetchNowPlayingMoviesUseCase
  }

  func fetchData() {
    screenState.value = .loading

    Task { [weak self] in
      do {
        let movies = try await fetchNowPlayingMoviesUseCase.execute()
        self?.screenState.value = .loaded(movies)
      } catch {
        self?.screenState.value = .error(AppError.map(error))
      }
    }
  }
}
