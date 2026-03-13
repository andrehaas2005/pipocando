//
//  HomeViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import Foundation

protocol HomeRouting: AnyObject {
  func showMovieDetails(_ movie: Movie)
}

@MainActor
class HomeViewModel {
  private let fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase
  weak var coordinator: (any HomeRouting)?
  var screenState: Observable<MoviePosterState> = .init(.idle)

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
